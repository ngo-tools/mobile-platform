//! Room details: members and per-room notification settings.

use matrix_sdk::{
    notification_settings::{IsEncrypted, IsOneToOne, NotificationSettings, RoomNotificationMode},
    room::RoomMemberRole,
    ruma::{events::room::member::MembershipState, RoomId},
    Room, RoomMemberships,
};
use tokio::sync::OnceCell;

use crate::{
    api::{client::ChatClient, error::ChatError},
    runtime::on_runtime,
};

pub enum MemberState {
    Joined,
    Invited,
}

pub enum MemberRole {
    Admin,
    Moderator,
    User,
}

pub struct Member {
    pub user_id: String,
    pub display_name: Option<String>,
    /// `mxc://` URI of the avatar (fetch via the media API).
    pub avatar_url: Option<String>,
    pub state: MemberState,
    pub role: MemberRole,
    pub is_own: bool,
}

#[derive(Clone, Copy, Debug, PartialEq)]
pub enum NotificationMode {
    AllMessages,
    MentionsOnly,
    Mute,
}

pub struct RoomNotificationSettings {
    pub mode: NotificationMode,
    /// True when the room follows the account default for its kind.
    pub is_default: bool,
}

impl ChatClient {
    /// Joined and invited members, fetched from the server if not complete.
    pub async fn room_members(&self, room_id: String) -> Result<Vec<Member>, ChatError> {
        let room = self.room(&room_id)?;
        on_runtime(async move {
            let own_user_id = room.own_user_id().to_owned();
            let members = room
                .members(RoomMemberships::JOIN | RoomMemberships::INVITE)
                .await?;
            Ok(members
                .iter()
                .map(|member| Member {
                    user_id: member.user_id().to_string(),
                    display_name: member.display_name().map(ToOwned::to_owned),
                    avatar_url: member.avatar_url().map(ToString::to_string),
                    state: if *member.membership() == MembershipState::Invite {
                        MemberState::Invited
                    } else {
                        MemberState::Joined
                    },
                    role: member_role(member.suggested_role_for_power_level()),
                    is_own: member.user_id() == own_user_id,
                })
                .collect())
        })
        .await
    }

    pub async fn room_notification_settings(
        &self,
        room_id: String,
    ) -> Result<RoomNotificationSettings, ChatError> {
        let room = self.room(&room_id)?;
        let settings = self.notification_settings.clone();
        on_runtime(async move {
            let settings = shared_settings(&room, &settings).await;
            if let Some(mode) = settings
                .get_user_defined_room_notification_mode(room.room_id())
                .await
            {
                return Ok(RoomNotificationSettings {
                    mode: from_sdk(mode),
                    is_default: false,
                });
            }
            let is_encrypted = room.latest_encryption_state().await?.is_encrypted();
            let is_one_to_one = room.active_members_count() == 2;
            let mode = settings
                .get_default_room_notification_mode(
                    IsEncrypted::from(is_encrypted),
                    IsOneToOne::from(is_one_to_one),
                )
                .await;
            Ok(RoomNotificationSettings {
                mode: from_sdk(mode),
                is_default: true,
            })
        })
        .await
    }

    /// Sets the room's mode; `None` restores the account default.
    pub async fn set_room_notification_mode(
        &self,
        room_id: String,
        mode: Option<NotificationMode>,
    ) -> Result<(), ChatError> {
        let room = self.room(&room_id)?;
        let settings = self.notification_settings.clone();
        on_runtime(async move {
            let settings = shared_settings(&room, &settings).await;
            // The room list reads the cached mode; sync would only refresh it
            // once the push rules come back.
            match mode {
                Some(mode) => {
                    settings
                        .set_room_notification_mode(room.room_id(), to_sdk(mode))
                        .await?;
                    room.update_cached_user_defined_notification_mode(to_sdk(mode));
                }
                None => {
                    settings
                        .delete_user_defined_room_rules(room.room_id())
                        .await?;
                    room.clear_user_defined_notification_mode();
                }
            }
            Ok(())
        })
        .await
    }

    pub(crate) fn room(&self, room_id: &str) -> Result<Room, ChatError> {
        let room_id =
            RoomId::parse(room_id).map_err(|error| ChatError::invalid(error.to_string()))?;
        self.client.get_room(&room_id).ok_or(ChatError::NotFound)
    }
}

async fn shared_settings(
    room: &Room,
    settings: &OnceCell<NotificationSettings>,
) -> NotificationSettings {
    settings
        .get_or_init(|| async { room.client().notification_settings().await })
        .await
        .clone()
}

pub(crate) fn from_sdk(mode: RoomNotificationMode) -> NotificationMode {
    match mode {
        RoomNotificationMode::AllMessages => NotificationMode::AllMessages,
        RoomNotificationMode::MentionsAndKeywordsOnly => NotificationMode::MentionsOnly,
        RoomNotificationMode::Mute => NotificationMode::Mute,
    }
}

fn to_sdk(mode: NotificationMode) -> RoomNotificationMode {
    match mode {
        NotificationMode::AllMessages => RoomNotificationMode::AllMessages,
        NotificationMode::MentionsOnly => RoomNotificationMode::MentionsAndKeywordsOnly,
        NotificationMode::Mute => RoomNotificationMode::Mute,
    }
}

fn member_role(role: RoomMemberRole) -> MemberRole {
    match role {
        RoomMemberRole::Creator | RoomMemberRole::Administrator => MemberRole::Admin,
        RoomMemberRole::Moderator => MemberRole::Moderator,
        RoomMemberRole::User => MemberRole::User,
    }
}

#[cfg(test)]
mod tests {
    use super::{from_sdk, to_sdk, NotificationMode};

    #[test]
    fn maps_notification_modes_both_ways() {
        for mode in [
            NotificationMode::AllMessages,
            NotificationMode::MentionsOnly,
            NotificationMode::Mute,
        ] {
            assert_eq!(from_sdk(to_sdk(mode)), mode);
        }
    }
}
