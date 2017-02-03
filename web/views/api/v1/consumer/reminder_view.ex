defmodule Playdays.Api.V1.Consumer.ReminderView do
  use Playdays.Web, :view

  alias Playdays.Api.V1.Consumer.FriendView
  alias Playdays.Api.V1.Consumer.PrivateEventView
  alias Playdays.Api.V1.Consumer.PlaceView

  def render("index.json", %{reminders: reminders}) do
    %{data: render_many(reminders, __MODULE__, "reminder.json")}
  end

  def render("show.json", %{reminder: reminder}) do
    %{data: render_one(reminder, __MODULE__, "reminder.json")}
  end

  def render("reminder.json", %{reminder: reminder}) do
    _render(reminder)
  end

  defp _render(reminder) do
    %{
      id: reminder.id,
      inserted_at: (reminder.inserted_at |> Ecto.DateTime.to_erl |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
      state: reminder.state,
      reminder_type: reminder.reminder_type,
      content: reminder |> _render_content
    }
  end

  defp _render_content(reminder) do
    case reminder.reminder_type do
      "friendRequestReminder" ->
         %{
           id: reminder.friend_request.id,
           friend_id: reminder.friend_request.requester.id,
           name: reminder.friend_request.requester.name,
           image: reminder.friend_request.requester.fb_user_id
         }
      "acceptedFriendRequestReminder" ->
        %{
           id: reminder.friend_request.id,
           friend_id: reminder.friend_request.requestee_id,
           name: reminder.friend_request.requestee.name,
           image: reminder.friend_request.requestee.fb_user_id
         }
      "joinedPublicEventReminder" ->
         %{
           id: reminder.session.time_slot.event_id,
           name: reminder.session.time_slot.event.name,
           date: _render_date(reminder.session.time_slot.date),
           session_id: reminder.session_id,
           time_slot_id: reminder.session.time_slot_id,
         }
      "sharedPublicEventReminder" ->
         %{
           id: reminder.session.time_slot.event_id,
           name: reminder.session.time_slot.event.name,
           date: _render_date(reminder.session.time_slot.date),
           consumer_name: reminder.session.consumer.name,
           session_id: reminder.session_id,
           time_slot_id: reminder.session.time_slot_id,
           image: reminder.session.consumer.fb_user_id,
         }
      "privateEventInvitationReminder" ->
          invitation = reminder.private_event_invitation
          private_event = invitation.private_event
          %{
            id: invitation.id,
            state: invitation.state,
            private_event: render_one(private_event, PrivateEventView, "private_event_details.json"),
          }
      "newPrivateEventParticipationReminder" ->
          participation = reminder.private_event_participation
          private_event = participation.private_event
          %{
            id: participation.id,
            private_event: render_one(private_event, PrivateEventView, "private_event_details.json")
          }
      # "joinedTrialClassReminder"
      # "rejectedTrialClassReminder"
      _ ->
         %{
           id: reminder.session.time_slot.trial_class_id,
           name: reminder.session.time_slot.trial_class.name,
           date: _render_date(reminder.session.time_slot.date),
           session_id: reminder.session_id,
           time_slot_id: reminder.session.time_slot_id,
         }
    end
  end

  defp _render_date(date) do
    ({date |> Ecto.Date.to_erl, {0, 0, 0}} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000
  end

end
