defmodule Playdays.Api.V1.Consumer.SessionControllerTest do
  use Playdays.ConnCase, async: false

  import Mock
  import Playdays.Utils.MapUtils

  alias Playdays.Services.Consumer.Consumer.JoinSession
  alias Playdays.Queries.SessionQuery
  alias Playdays.Queries.ReminderQuery
  alias Playdays.Consumer.NotificationChannel
  alias Playdays.Services.Consumer.FriendRequest.CreateFriendRequest
  alias Playdays.Services.Consumer.FriendRequest.AcceptFriendRequest

  setup do
    consumer = create(:consumer)
    time_slots = create(:event).time_slots
    device = hd(consumer.devices)

    conn = conn()
            |> put_req_header("accept", "application/json")
            |> put_req_header("x-fb-user-id", consumer.fb_user_id)
            |> put_req_header("x-device-uuid", device.uuid)
            |> put_req_header("x-fb-access-token", device.fb_access_token)

    {:ok, conn: conn, consumer: consumer, time_slots: time_slots}
  end

  # test "list all current consumer joined session", %{conn: conn, consumer: consumer, time_slots: time_slots} do
  #   Enum.map(time_slots, &JoinSession.call(&1, consumer))
  #
  #   expected_data =
  #     %{status: "joined", consumer_id: consumer.id}
  #     |> SessionQuery.find_many(preload: [time_slot: [:event, :trial_class]])
  #     |> Enum.map(&expected_render/1)
  #
  #   conn = get conn, api_v1_consumer_session_path(conn, :index)
  #
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #   assert conn.status == 200
  #   assert response_data == expected_data
  # end

  # test "join a time slot", %{conn: conn, consumer: consumer, time_slots: [time_slot|_]} do
  #   data = %{
  #     time_slot_id: time_slot.id
  #   }
  #
  #   conn = post conn, api_v1_consumer_session_path(conn, :create), data
  #
  #   sessions = SessionQuery.find_many(%{consumer_id: consumer.id, time_slot_id: time_slot.id}, preload: [time_slot: [:event, :trial_class]])
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #
  #   assert length(sessions) == 1
  #   assert response_data == expected_render(hd(sessions))
  # end

  # test "cannot join the same time slot twice", %{conn: conn, consumer: consumer, time_slots: [time_slot|_]} do
  #   data = %{
  #     time_slot_id: time_slot.id
  #   }
  #
  #   { :ok, session } = JoinSession.call(time_slot, consumer)
  #
  #   conn = post conn, api_v1_consumer_session_path(conn, :create), data
  #
  #   assert_status(conn, 422)
  #
  #   session = SessionQuery.find_many(%{consumer_id: consumer.id, time_slot_id: time_slot.id})
  #
  #   assert length(session) == 1
  # end

  # test "share session will create reminder and broadcast", %{conn: conn, consumer: consumer, time_slots: [time_slot|_]} do
  #   with_mock NotificationChannel, [new_reminder_created: fn(_) -> {:ok, "things"} end] do
  #     another_consumer = create(:consumer)
  #     { :ok, session } = JoinSession.call(time_slot, consumer)
  #
  #     data = %{id: session.id, friends_consumer_ids: [another_consumer.id]}
  #
  #     conn = post(conn, api_v1_consumer_session_path(conn, :share_with_friends), data)
  #     assert_status(conn, 204)
  #
  #     reminders = ReminderQuery.find_many(
  #       %{consumer_id: another_consumer.id, reminder_type: "sharedPublicEventReminder"},
  #       preload: [session: [:consumer, time_slot: [:event, :trial_class]]]
  #     )
  #
  #     assert 1 == length reminders
  #
  #     assert called NotificationChannel.new_reminder_created hd(reminders)
  #   end
  # end

  defp expected_render(session) do
    time_slot = %{
      id: session.time_slot.id,
      date: ({session.time_slot.date |> Ecto.Date.to_erl, {0, 0, 0}} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
      from: ({{1970, 1, 1}, session.time_slot.from |> Ecto.Time.to_erl} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
      to: ({{1970, 1, 1}, session.time_slot.to |> Ecto.Time.to_erl} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
    }
    if !is_nil session.time_slot.event_id do
      time_slot =
        time_slot
        |> Map.put(:event_id, session.time_slot.event_id)
        |> Map.put(:event, %{
          contact_number: session.time_slot.event.contact_number,
          description: session.time_slot.event.description,
          id: session.time_slot.event.id,
          image: session.time_slot.event.image,
          lat: session.time_slot.event.lat,
          long: session.time_slot.event.long,
          is_featured: session.time_slot.event.is_featured,
          location_address: session.time_slot.event.location_address,
          joined_consumer_number: session.time_slot.event.joined_consumer_number,
          booking_hotline: session.time_slot.event.booking_hotline,
          booking_url: session.time_slot.event.booking_url,
          booking_email: session.time_slot.event.booking_email,
          name: session.time_slot.event.name,
          number_of_likes: session.time_slot.event.number_of_likes,
          website_url: session.time_slot.event.website_url,
          price_range: %{
            hi: session.time_slot.event.price_range.hi,
            lo: session.time_slot.event.price_range.lo,
          },
        })
    end
    if !is_nil session.time_slot.trial_class_id do
      time_slot =
        time_slot
        |> Map.put(:trial_class_id, session.time_slot.trial_class_id)
        |> Map.put(:trial_class, %{
          contact_number: session.time_slot.trial_class.contact_number,
          description: session.time_slot.trial_class.description,
          id: session.time_slot.trial_class.id,
          image: session.time_slot.trial_class.image,
          location_address: session.time_slot.trial_class.location_address,
          booking_hotline: session.time_slot.trial_class.booking_hotline,
          booking_url: session.time_slot.trial_class.booking_url,
          booking_email: session.time_slot.trial_class.booking_email,
          name: session.time_slot.trial_class.name,
          website_url: session.time_slot.trial_class.website_url,
        })
    end

    %{
      id: session.id,
      status: session.status,
      time_slot: time_slot
    }
  end
end
