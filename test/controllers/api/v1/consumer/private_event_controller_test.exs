defmodule Playdays.Api.V1.Consumer.PrivateEventControllerTest do
  import Mock
  use Playdays.ConnCase, async: false
  import Playdays.Utils.MapUtils

  alias Playdays.Consumer
  alias Playdays.PrivateEvent
  alias Playdays.Queries.ReminderQuery
  alias Playdays.Consumer.NotificationChannel
  alias Playdays.Services.Consumer.PushNotification.SendPushNotification


  setup do
    place = create(:place)
    consumer = create(:consumer) |> Repo.preload(:friends)
    another_consumer = create(:consumer) |> Repo.preload(:friends)
    consumer |> Consumer.add_friend(another_consumer) |> Repo.update!
    another_consumer |> Consumer.add_friend(consumer) |> Repo.update!
    device = hd(consumer.devices)
    %PrivateEvent{}
    |> PrivateEvent.changeset(%{
        name: "test",
        date: 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now),
        from: 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now),
        place_id: place.id,
        consumer_id: consumer.id,
        private_event_participations: [
          %{
            consumer_id: another_consumer.id
          }
        ]
      })
    |> Repo.insert!

    %PrivateEvent{}
    |> PrivateEvent.changeset(%{
        name: "test",
        date: 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now),
        from: 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now),
        place_id: place.id,
        consumer_id: another_consumer.id,
        private_event_participations: [
          %{
            consumer_id: consumer.id
          }
        ]
      })
    |> Repo.insert!

    consumer = consumer |> Repo.preload([:private_events, :joined_private_events, :private_event_invitations])
    another_consumer = another_consumer |> Repo.preload([:private_events, :joined_private_events, :private_event_invitations])
    conn = conn()
            |> put_req_header("accept", "application/json")
            |> put_req_header("x-fb-user-id", consumer.fb_user_id)
            |> put_req_header("x-device-uuid", device.uuid)
            |> put_req_header("x-fb-access-token", device.fb_access_token)

    {:ok, conn: conn, place: place, consumer: consumer, another_consumer: another_consumer}
  end

  # test "list all private events", %{conn: conn, consumer: consumer, another_consumer: another_consumer} do
  #   private_events = consumer.private_events |> Repo.preload([:place, :consumer, private_event_invitations: [:consumer], private_event_participations: [:consumer]])
  #   joined_private_events = consumer.joined_private_events |> Repo.preload([:place, :consumer, private_event_invitations: [:consumer], private_event_participations: [:consumer]])
  #   all_private_events = private_events ++ joined_private_events
  #   conn = get(conn, api_v1_consumer_private_event_path(conn, :index))
  #   assert conn.status == 200
  #   expected_data = Enum.map(all_private_events, &expected_render/1)
  #
  #
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #   assert response_data == expected_data
  # end

  # test "host read a private event", %{conn: conn, consumer: consumer} do
  #   private_event = hd consumer.private_events
  #   private_event = private_event |> Repo.preload([:place, :consumer, private_event_invitations: [:consumer], private_event_participations: [:consumer]])
  #
  #   conn = get conn, api_v1_consumer_private_event_path(conn, :show, private_event)
  #   assert conn.status == 200
  #
  #   expected_data = private_event |> expected_render
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #   assert  response_data == expected_data
  # end

  # test "invitee read a priate event", %{conn: conn, another_consumer: another_consumer} do
  #   private_event_participation = hd(another_consumer.private_event_participations)
  #   private_event_participation = private_event_participation |> Repo.preload([:private_event])
  #   private_event = private_event_participation.private_event |> Repo.preload([:place, :consumer, private_event_invitations: [:consumer], private_event_participations: [:consumer]])
  #
  #   conn = get conn, api_v1_consumer_private_event_path(conn, :show, private_event)
  #   assert conn.status == 200
  #
  #   expected_data = private_event |> expected_render
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #   assert  response_data == expected_data
  # end


  # test "create a private event", %{conn: conn, place: place, consumer: consumer} do
  #   data = %{
  #     name: "test",
  #     date: 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now),
  #     from: 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now),
  #     place_id: place.id,
  #   }
  #
  #   conn = post(conn, api_v1_consumer_private_event_path(conn, :create), data)
  #   assert conn.status == 201
  #   private_event = conn.assigns.new_private_event
  #   expected_data = expected_render private_event
  #   response_data = json_response(conn, 201)["data"] |> to_atom_keys
  #
  #   assert response_data == expected_data
  # end

  # test "create a private event with invitation", %{conn: conn, place: place, consumer: consumer, another_consumer: another_consumer} do
  #   with_mock NotificationChannel, mocked_notification_channel_func_list do
  #     with_mock SendPushNotification, [call: fn(_) -> end] do
  #       data = %{
  #         name: "test",
  #         date: 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now),
  #         from: 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now),
  #         place_id: place.id,
  #         invited_consumer_ids: [another_consumer.id]
  #       }
  #
  #       conn = post(conn, api_v1_consumer_private_event_path(conn, :create), data)
  #       assert conn.status == 201
  #
  #       private_event = conn.assigns.new_private_event
  #       expected_data = expected_render private_event
  #       response_data = json_response(conn, 201)["data"] |> to_atom_keys
  #       assert response_data == expected_data
  #
  #       reminders = private_event.private_event_invitations |> Enum.map(fn(i) ->
  #         ReminderQuery.find_one(
  #          %{ private_event_invitation_id: i.id },
  #          preload: [
  #            private_event_invitation: [private_event: [:place, :consumer, private_event_invitations: [:consumer], private_event_participations: [:consumer]]]
  #          ]
  #        )
  #       end)
  #
  #       reminders |> Enum.each(fn(r) ->
  #         assert called NotificationChannel.new_reminder_created(r)
  #       end)
  #
  #       another_consumer = another_consumer |> Repo.preload([:reminders])
  #       another_consumer_reminders_count = length another_consumer.reminders
  #
  #
  #       assert another_consumer_reminders_count == 1
  #       host = private_event.consumer
  #       assert called SendPushNotification.call(%{type: "private_event_invitation", host: host, private_event_invitations: private_event.private_event_invitations})
  #     end
  #   end
  # end

  defp expected_render(private_event) do
    %{
      id: private_event.id,
      name: private_event.name,
      host: private_event.consumer |> _render_consumer,
      place: %{
        id: private_event.place.id,
        name: private_event.place.name,
        website_url: private_event.place.website_url,
        contact_number: private_event.place.contact_number,
        location_address: private_event.place.location_address,
        description: private_event.place.description,
        is_featured: private_event.place.is_featured,
        image: private_event.place.image,
        lat: private_event.place.lat,
        long: private_event.place.long,
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
      date: private_event.date |> _render_date,
      from: private_event.from |> _render_time,
      inserted_at: Ecto.DateTime.to_iso8601(private_event.inserted_at),
      updated_at: Ecto.DateTime.to_iso8601(private_event.inserted_at),
    }
  end

  defp _render_consumer(consumer) do
    %{
      id: consumer.id,
      name: consumer.name,
      fb_user_id: consumer.fb_user_id,
      about_me: consumer.about_me,
      inserted_at: Ecto.DateTime.to_iso8601(consumer.inserted_at),
      updated_at: Ecto.DateTime.to_iso8601(consumer.updated_at),
    }
  end

  defp _render_date(date) do
    ({date |> Ecto.Date.to_erl, {0, 0, 0}} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000
  end

  defp _render_time(time) do
    ({{1970, 1, 1}, time |> Ecto.Time.to_erl} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000
  end


  defp mocked_notification_channel_func_list() do
    [
      new_reminder_created: fn(_) ->
        {:ok, "things"}
      end,
    ]
  end

end
