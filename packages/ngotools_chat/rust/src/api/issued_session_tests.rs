//! Issued sessions against the local e2e server (`e2e/issued_session.py`
//! sets the environment and runs this test).

use std::time::Duration;

use crate::api::{
    client::{ChatClient, ChatConfig},
    lifecycle::SyncStatus,
};

fn env(name: &str) -> String {
    std::env::var(name).unwrap_or_else(|_| panic!("{name} is not set"))
}

fn config(dir: &std::path::Path) -> ChatConfig {
    ChatConfig {
        homeserver_url: env("CHAT_E2E_HOMESERVER"),
        data_dir: dir.join("data").to_string_lossy().into_owned(),
        cache_dir: dir.join("cache").to_string_lossy().into_owned(),
        store_key: vec![7; 32],
        client_name: "Issued session test".to_owned(),
        client_uri: "https://ngo.tools/".to_owned(),
        redirect_uri: "tools.ngo.test:/callback".to_owned(),
        dev_root_certificate_pem: Some(
            std::fs::read_to_string(env("CHAT_E2E_CA")).expect("dev CA"),
        ),
        cross_process_holder: None,
    }
}

#[tokio::test(flavor = "multi_thread")]
#[ignore = "needs the local e2e server (e2e/issued_session.py)"]
async fn signs_in_with_an_issued_token_and_swaps_it_while_running() {
    let user_id = env("CHAT_E2E_USER_ID");
    let device_id = env("CHAT_E2E_DEVICE_ID");
    let dir = std::env::temp_dir().join(format!("issued-session-{}", std::process::id()));

    let client = ChatClient::create(config(&dir)).await.unwrap();
    let info = client
        .sign_in_with_token(user_id.clone(), device_id.clone(), env("CHAT_E2E_TOKEN"))
        .await
        .unwrap();
    assert_eq!(info.device_id, device_id);
    assert_eq!(client.whoami().await.unwrap(), user_id);

    client.start_sync().await.unwrap();
    wait_for_running(&client).await;

    let renewed = regenerate().await;
    client.update_access_token(renewed.clone()).await.unwrap();
    assert_eq!(client.client.access_token(), Some(renewed.clone()));
    assert_eq!(client.whoami().await.unwrap(), user_id);
    client.shutdown().await.unwrap();
    drop(client);

    let restarted = ChatClient::create(config(&dir)).await.unwrap();
    let restored = restarted.restore_session().await.unwrap().unwrap();
    assert_eq!(restored.device_id, device_id);
    assert_eq!(restarted.client.access_token(), Some(renewed));
    assert_eq!(restarted.whoami().await.unwrap(), user_id);

    // NGO.Tools revokes issued sessions; logging out only forgets it here.
    restarted.logout().await.unwrap();
    restarted.shutdown().await.unwrap();
    drop(restarted);
    let after_logout = ChatClient::create(config(&dir)).await.unwrap();
    assert!(after_logout.restore_session().await.unwrap().is_none());
    after_logout.shutdown().await.unwrap();
}

/// What NGO.Tools does when an app renews: same MAS session, same device.
async fn regenerate() -> String {
    let http = matrix_sdk::reqwest::Client::builder()
        .add_root_certificate(
            matrix_sdk::reqwest::Certificate::from_pem(
                std::fs::read(env("CHAT_E2E_CA")).unwrap().as_slice(),
            )
            .unwrap(),
        )
        .build()
        .unwrap();
    let mas = env("CHAT_E2E_MAS");
    let credentials = env("CHAT_E2E_MAS_ADMIN_CLIENT");
    let (id, secret) = credentials.split_once(':').unwrap();
    let admin = request(
        http.post(format!("{mas}/oauth2/token"))
            .basic_auth(id, Some(secret))
            .header("content-type", "application/x-www-form-urlencoded")
            .body("grant_type=client_credentials&scope=urn:mas:admin"),
    )
    .await;
    let session = request(
        http.post(format!(
            "{mas}/api/admin/v1/personal-sessions/{}/regenerate",
            env("CHAT_E2E_SESSION_ID")
        ))
        .bearer_auth(admin["access_token"].as_str().unwrap())
        .header("content-type", "application/json")
        .body(r#"{"expires_in":3600}"#),
    )
    .await;
    session["data"]["attributes"]["access_token"]
        .as_str()
        .unwrap()
        .to_owned()
}

async fn request(builder: matrix_sdk::reqwest::RequestBuilder) -> serde_json::Value {
    let response = builder.send().await.unwrap().error_for_status().unwrap();
    serde_json::from_str(&response.text().await.unwrap()).unwrap()
}

async fn wait_for_running(client: &ChatClient) {
    let service = client.sync_service().await.unwrap();
    for _ in 0..100 {
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
