//! Acceptance against a real NGO.Tools instance: the app's background sign-in
//! through the NGO.Tools API with the real SDK. Needs an API token with
//! `chat:login` and `chat:read` in `CHAT_ACCEPTANCE_TOKEN` and the instance's
//! API origin in `CHAT_ACCEPTANCE_API` (e.g. `https://example.ngo.tools`).
//! Never prints tokens.

use std::time::Duration;

use crate::api::{
    client::{ChatClient, ChatConfig},
    lifecycle::SyncStatus,
};

fn env(name: &str) -> String {
    std::env::var(name).unwrap_or_else(|_| panic!("{name} is not set"))
}

fn config(homeserver: &str, dir: &std::path::Path) -> ChatConfig {
    ChatConfig {
        homeserver_url: homeserver.to_owned(),
        data_dir: dir.join("data").to_string_lossy().into_owned(),
        cache_dir: dir.join("cache").to_string_lossy().into_owned(),
        store_key: vec![9; 32],
        client_name: "NGO.Tools acceptance".to_owned(),
        client_uri: "https://ngo.tools/".to_owned(),
        redirect_uri: "tools.ngo.acceptance:/callback".to_owned(),
        dev_root_certificate_pem: None,
        cross_process_holder: None,
    }
}

#[tokio::test(flavor = "multi_thread")]
#[ignore = "needs a real NGO.Tools instance and API token"]
async fn signs_in_in_the_background_and_renews_through_ngo_tools() {
    let issued = ngo_tools(
        "POST",
        "chat/sessions",
        Some(r#"{"device_name":"Abnahme"}"#),
    )
    .await;
    let session = &issued["data"];
    let user_id = session["matrix_user_id"].as_str().unwrap().to_owned();
    let device_id = session["device_id"].as_str().unwrap().to_owned();
    let homeserver = session["homeserver_url"].as_str().unwrap().to_owned();
    println!(
        "issued: user {user_id}, device {device_id}, expires {}",
        session["expires_at"]
    );

    let dir = std::env::temp_dir().join(format!("chat-acceptance-{}", std::process::id()));
    let client = ChatClient::create(config(&homeserver, &dir)).await.unwrap();
    let info = client
        .sign_in_with_token(
            user_id.clone(),
            device_id.clone(),
            session["access_token"].as_str().unwrap().to_owned(),
        )
        .await
        .unwrap();
    assert_eq!(info.device_id, device_id);
    assert_eq!(client.whoami().await.unwrap(), user_id);
    println!("signed in without any input");

    client.start_sync().await.unwrap();
    wait_for_running(&client).await;
    tokio::time::sleep(Duration::from_secs(5)).await;
    println!(
        "sync running, joined rooms: {}",
        client.client.joined_rooms().len()
    );

    let renewed = ngo_tools("POST", "chat/sessions/current/renew", None).await;
    assert_eq!(renewed["data"]["device_id"].as_str().unwrap(), device_id);
    let renewed_token = renewed["data"]["access_token"].as_str().unwrap().to_owned();
    client
        .update_access_token(renewed_token.clone())
        .await
        .unwrap();
    assert_eq!(client.client.access_token(), Some(renewed_token.clone()));
    assert_eq!(client.whoami().await.unwrap(), user_id);
    println!(
        "renewed: same device, running session took over the new token, expires {}",
        renewed["data"]["expires_at"]
    );
    client.shutdown().await.unwrap();
    drop(client);

    let restarted = ChatClient::create(config(&homeserver, &dir)).await.unwrap();
    let restored = restarted.restore_session().await.unwrap().unwrap();
    assert_eq!(restored.device_id, device_id);
    assert_eq!(restarted.whoami().await.unwrap(), user_id);
    println!("restored after restart with the renewed token");
    restarted.shutdown().await.unwrap();
    drop(restarted);
    std::fs::remove_dir_all(&dir).ok();
}

async fn ngo_tools(method: &str, path: &str, body: Option<&str>) -> serde_json::Value {
    let http = matrix_sdk::reqwest::Client::new();
    let url = format!("{}/api/v3/{path}", env("CHAT_ACCEPTANCE_API"));
    let request = match method {
        "POST" => http.post(url),
        _ => http.get(url),
    }
    .bearer_auth(env("CHAT_ACCEPTANCE_TOKEN"))
    .header("accept", "application/json")
    .header("content-type", "application/json")
    .body(body.unwrap_or("{}").to_owned());
    let response = request.send().await.unwrap();
    let status = response.status();
    let text = response.text().await.unwrap();
    assert!(status.is_success(), "{method} {path}: {status}");
    serde_json::from_str(&text).unwrap()
}

async fn wait_for_running(client: &ChatClient) {
    let service = client.sync_service().await.unwrap();
    for _ in 0..200 {
        if matches!(
            crate::api::lifecycle::sync_status(&service.state().get()),
            SyncStatus::Running
        ) {
            return;
        }
        tokio::time::sleep(Duration::from_millis(100)).await;
    }
    panic!("sync did not start");
}
