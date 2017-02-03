defmodule Playdays.Api.V1.Consumer.ReminderControllerTest do
  use Playdays.ConnCase, async: true

  import Playdays.Utils.MapUtils

  alias Playdays.Queries.ReminderQuery

  setup do
    consumer = create(:consumer)
    second_consumer = create(:consumer)
    third_consumer = create(:consumer)
    device = hd(consumer.devices)

    event_time_slot = hd create(:event).time_slots
    trial_class_time_slot = hd create(:trial_class).time_slots
    event_session = create(:session, time_slot: event_time_slot, consumer: consumer)
    trial_class_session = create(:session, time_slot: trial_class_time_slot, consumer: consumer)

    friend_request1 = create(:friend_request, requestee: consumer)
    friend_request2 = create(:friend_request, requester: consumer)
    private_event = create(:private_event, consumer: consumer)
    private_event_participation = create(:private_event_participation, %{private_event: private_event, consumer: second_consumer})
    private_event_invitation = create(:private_event_invitation, %{private_event: private_event, consumer: third_consumer})

    reminders = [
      create(:reminder, consumer: consumer, session: event_session, reminder_type: "joinedPublicEventReminder"),
      create(:reminder, consumer: consumer, session: trial_class_session, reminder_type: "joinedTrialClassReminder"),
      create(:reminder, consumer: consumer, friend_request: friend_request1, reminder_type: "friendRequestReminder"),
      create(:reminder, consumer: consumer, friend_request: friend_request2, reminder_type: "acceptedFriendRequestReminder"),
      create(:reminder, consumer: consumer, private_event_invitation: private_event_invitation, reminder_type: "privateEventInvitationReminder"),
      create(:reminder, consumer: consumer, private_event_participation: private_event_participation, reminder_type: "newPrivateEventParticipationReminder")
    ]

    conn = conn()
            |> put_req_header("accept", "application/json")
            |> put_req_header("x-fb-user-id", consumer.fb_user_id)
            |> put_req_header("x-device-uuid", device.uuid)
            |> put_req_header("x-fb-access-token", device.fb_access_token)

    {:ok, conn: conn, consumer: consumer, reminders: reminders}
  end

  # test "list all current consumer reminders", %{conn: conn, consumer: %{id: id}} do
  #   expected_data =
  #     ReminderQuery.where_consumer_id_is(id)
  #     |> Enum.map(&expected_render/1)
  #
  #   conn = get conn, api_v1_consumer_reminder_path(conn, :index)
  #
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #   assert conn.status == 200
  #   assert response_data == expected_data
  # end

  # test "mark a reminder as read", %{conn: conn, reminders: [%{id: id}|_]} do
  #   reminder = ReminderQuery.by_id id
  #   assert reminder.state == "unread"
  #
  #   data = %{id: reminder.id}
  #   conn = put(conn, api_v1_consumer_reminder_path(conn, :mark_read, reminder), data)
  #
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #
  #   assert conn.status == 200
  #   assert response_data == expected_render(Map.put(reminder, :state, "read"))
  # end

  # test "mark a reminder as archived", %{conn: conn, reminders: [%{id: id}|_]} do
  #   reminder = ReminderQuery.by_id id
  #   assert reminder.state == "unread"
  #
  #   data = %{id: reminder.id}
  #   conn = put(conn, api_v1_consumer_reminder_path(conn, :archive, reminder), data)
  #
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #
  #   assert conn.status == 200
  #   assert response_data == expected_render(Map.put(reminder, :state, "archived"))
  # end

  defp expected_render(reminder) do
    %{
      id: reminder.id,
      inserted_at: (reminder.inserted_at |> Ecto.DateTime.to_erl |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
      state: reminder.state,
      reminder_type: reminder.reminder_type,
      content: reminder |> _render_content_and_type
    }

  end

  defp _render_content_and_type(reminder) do
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
        private_event_invitation = reminder.private_event_invitation
        private_event = private_event_invitation.private_event

        %{
          id: private_event_invitation.id,
          state: private_event_invitation.state,
          private_event: private_event |> _render_private_event
        }
      "newPrivateEventParticipationReminder" ->
        participation = reminder.private_event_participation
        private_event = participation.private_event
        %{
          id: participation.id,
          private_event: private_event |> _render_private_event
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

  defp _render_private_event(private_event) do
    host = private_event.consumer
    place = private_event.place
    %{
      id: private_event.id,
      name: private_event.name,
      date: private_event.date |> _render_date,
      from: private_event.from |> _render_time,
      host: %{
        id: host.id,
        name: host.name,
        fb_user_id: host.fb_user_id,
        about_me: host.about_me,
        inserted_at: Ecto.DateTime.to_iso8601(place.inserted_at),
        updated_at: Ecto.DateTime.to_iso8601(place.inserted_at),
      },
      place: %{
        id: place.id,
        name: place.name,
        website_url: place.website_url,
        contact_number: place.contact_number,
        location_address: place.location_address,
        description: place.description,
        is_featured: place.is_featured,
        image: place.image,
        lat: place.lat,
        long: place.long,
      },
      private_event_participations: private_event.private_event_participations |> Enum.map(&%{
        id: &1.id,
        private_event_id: &1.private_event_id,
        consumer_id: &1.consumer_id,
        consumer: %{
          id: &1.consumer.id,
          name: &1.consumer.name,
          about_me: &1.consumer.about_me,
          fb_user_id: &1.consumer.fb_user_id,
          inserted_at: Ecto.DateTime.to_iso8601(&1.consumer.inserted_at),
          updated_at: Ecto.DateTime.to_iso8601(&1.consumer.inserted_at),
        },
        inserted_at: Ecto.DateTime.to_iso8601(&1.inserted_at),
        updated_at: Ecto.DateTime.to_iso8601(&1.inserted_at),
      }),
      private_event_invitations: private_event.private_event_invitations |> Enum.map(&%{
        id: &1.id,
        private_event_id: &1.private_event_id,
        consumer_id: &1.consumer_id,
        state: &1.state,
        consumer: %{
          id: &1.consumer.id,
          name: &1.consumer.name,
          about_me: &1.consumer.about_me,
          fb_user_id: &1.consumer.fb_user_id,
          inserted_at: Ecto.DateTime.to_iso8601(&1.consumer.inserted_at),
          updated_at: Ecto.DateTime.to_iso8601(&1.consumer.inserted_at),
        },
        inserted_at: Ecto.DateTime.to_iso8601(&1.inserted_at),
        updated_at: Ecto.DateTime.to_iso8601(&1.inserted_at),
      }),
      inserted_at: Ecto.DateTime.to_iso8601(private_event.inserted_at),
      updated_at: Ecto.DateTime.to_iso8601(private_event.inserted_at),
    }
  end

  defp _render_date(date) do
    ({date |> Ecto.Date.to_erl, {0, 0, 0}} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000
  end

  defp _render_time(time) do
    ({{1970, 1, 1}, time |> Ecto.Time.to_erl} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000
  end
end
