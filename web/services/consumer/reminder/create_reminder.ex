defmodule Playdays.Services.Consumer.Reminder.CreateReminder do

  alias Playdays.Repo
  alias Playdays.Reminder

  def joined_public_event_reminder(%{id: id, consumer_id: cid}) do
    call_session(cid, id, "joinedPublicEventReminder")
  end

  def shared_session_reminder(target_id, %{id: id}) do
    call_session(target_id, id, "sharedPublicEventReminder")
  end

  def joined_trial_class_reminder(%{id: id, consumer_id: cid}) do
    call_session(cid, id, "joinedTrialClassReminder")
  end

  def rejected_trial_class_reminder(%{id: id, consumer_id: cid}) do
    call_session(cid, id, "rejectedTrialClassReminder")
  end

  def friend_request_reminder(%{id: id, requestee_id: cid}) do
    call_friend_request(cid, id, "friendRequestReminder")
  end

  def accepted_friend_request_reminder(%{id: id, requester_id: cid}) do
    call_friend_request(cid, id, "acceptedFriendRequestReminder")
  end

  defp call_session(consumer_id, session_id, reminder_type) do
    %Reminder{}
    |> Reminder.changeset(%{
      consumer_id: consumer_id,
      session_id: session_id,
      reminder_type: reminder_type
    })
    |> Repo.insert
  end

  defp call_friend_request(consumer_id, friend_request_id, reminder_type) do
    %Reminder{}
    |> Reminder.changeset(%{
      consumer_id: consumer_id,
      friend_request_id: friend_request_id,
      reminder_type: reminder_type
    })
    |> Repo.insert
  end

  def call!(%{type: "privateEventInvitationReminder" = type, invitations: invitations}) do
    invitations |> Enum.map(fn(invitation) ->
      %Reminder{}
      |> Reminder.changeset(%{
          consumer_id: invitation.consumer_id,
          reminder_type: type,
          private_event_invitation_id: invitation.id,
        })
      |> Repo.insert!
    end)
  end

  def call!(%{type: "newPrivateEventParticipationReminder" = type, private_event_participation: private_event_participation}) do
    %Reminder{}
    |> Reminder.changeset(%{
        consumer_id: private_event_participation.private_event.consumer.id,
        reminder_type: type,
        private_event_participation_id: private_event_participation.id,
      })
    |> Repo.insert!
  end

end
