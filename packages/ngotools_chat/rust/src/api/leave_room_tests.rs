//! Leaving a room against the local e2e server (`e2e/leave_room.py` sets
//! the environment and runs this test).

use std::time::Duration;

use futures_util::{pin_mut, StreamExt};
use matrix_sdk::{ruma::api::client::room::create_room::v3::Request as CreateRoom, RoomState};

use crate::api::{
    client::{ChatClient, ChatConfig},
    rooms::{filter_for, RoomFilter},
};

fn env(name: &str) -> String {
    std::env::var(name).unwrap_or_else(|_| panic!("{name} is not set"))
}

#[tokio::test(flavor = "multi_thread")]
#[ignore = "needs the local e2e server (e2e/leave_room.py)"]
async fn a_left_room_leaves_the_room_list() {
    let dir = std::env::temp_dir().join(format!("leave-room-{}", std::process::id()));
    let client = ChatClient::create(ChatConfig {
        homeserver_url: env("CHAT_E2E_HOMESERVER"),
        data_dir: dir.join("data").to_string_lossy().into_owned(),
        cache_dir: dir.join("cache").to_string_lossy().into_owned(),
        store_key: vec![5; 32],
        client_name: "Leave room test".to_owned(),
        client_uri: "https://ngo.tools/".to_owned(),
        redirect_uri: "tools.ngo.test:/callback".to_owned(),
        dev_root_certificate_pem: Some(std::fs::read_to_string(env("CHAT_E2E_CA")).unwrap()),
        cross_process_holder: None,
    })
    .await
    .unwrap();
    client
        .sign_in_with_token(
            env("CHAT_E2E_USER_ID"),
            env("CHAT_E2E_DEVICE_ID"),
            env("CHAT_E2E_TOKEN"),
        )
        .await
        .unwrap();
    client.start_sync().await.unwrap();

    let room = client.client.create_room(CreateRoom::new()).await.unwrap();
    let room_id = room.room_id().to_owned();

    let service = client.sync_service().await.unwrap();
    let all_rooms = service.room_list_service().all_rooms().await.unwrap();
    let (stream, controller) = all_rooms.entries_with_dynamic_adapters(50);
    controller.set_filter(filter_for(RoomFilter::All));
    pin_mut!(stream);
    let mut visible = eyeball_im::Vector::new();

    // Wait until the new room shows up.
    tokio::time::timeout(Duration::from_secs(30), async {
        while !visible
            .iter()
            .any(|item: &matrix_sdk_ui::room_list_service::RoomListItem| item.room_id() == room_id)
        {
            for diff in stream.next().await.unwrap() {
                diff.apply(&mut visible);
            }
        }
    })
    .await
    .expect("room appears");
    println!("room listed");

    client.leave_room(room_id.to_string()).await.unwrap();
    println!("state right after leave: {:?}", room.state());

    let result = tokio::time::timeout(Duration::from_secs(20), async {
        loop {
            controller.set_filter(filter_for(RoomFilter::All));
            if let Ok(Some(diffs)) =
                tokio::time::timeout(Duration::from_secs(2), stream.next()).await
            {
                for diff in diffs {
                    diff.apply(&mut visible);
                }
            }
            println!(
                "state {:?}, listed {}",
                room.state(),
                visible.iter().any(|item| item.room_id() == room_id)
            );
            if room.state() == RoomState::Left
                && !visible.iter().any(|item| item.room_id() == room_id)
            {
                return;
            }
        }
    })
    .await;
    assert!(result.is_ok(), "left room still listed");
    client.shutdown().await.unwrap();
}
