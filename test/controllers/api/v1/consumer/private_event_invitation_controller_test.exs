defmodule Playdays.Api.V1.Consumer.PrivateEventInvitationControllerTest do
  import Mock
  use Playdays.ConnCase, async: false
  import Playdays.Utils.MapUtils

  alias Playdays.Consumer
  alias Playdays.PrivateEvent
  alias Playdays.Queries.ConsumerQuery
  alias Playdays.Queries.ReminderQuery
  alias Playdays.Queries.PrivateEventInvitationQuery
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
        consumer_id: another_consumer.id,
        private_event_invitations: [
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

  # test "accept a private event invitation", %{conn: conn, consumer: consumer} do
  #   with_mock NotificationChannel, mocked_notification_channel_func_list do
  #     with_mock SendPushNotification, [call: fn(_) -> end] do
  #       invitation = hd consumer.private_event_invitations
  #       data = %{
  #         action_type: "accept"
  #       }
  #
  #       conn = put(conn, api_v1_consumer_private_event_invitation_path(conn, :update, invitation), data)
  #       assert conn.status == 200
  #       invitation = conn.assigns.updated_private_event_invitation |> Repo.preload([private_event: [:consumer, :place, private_event_invitations: [:consumer], private_event_participations: [:consumer]]])
  #
  #       assert invitation.state == "accepted"
  #
  #       invitation = PrivateEventInvitationQuery.find_one(
  #                     %{ id: invitation.id },
  #                     preload: [:consumer, private_event: [:consumer, :place, private_event_participations: [:consumer], private_event_invitations: [:consumer]]]
  #                    )
  #       expected_data = expected_render invitation
  #       response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #       assert response_data == expected_data
  #
  #       private_event_participations_count = length invitation.private_event.private_event_participations
  #       assert private_event_participations_count == 1
  #
  #       consumer = ConsumerQuery.find_one(
  #                     %{ id: consumer.id },
  #                     preload: [:joined_private_events]
  #                    )
  #       joined_private_events_count = length consumer.joined_private_events
  #       assert joined_private_events_count == 1
  #
  #       participation = hd (invitation.private_event.private_event_participations)
  #
  #       reminder =  ReminderQuery.find_one(%{
  #                       consumer_id: invitation.private_event.consumer.id,
  #                       private_event_participation_id: participation.id
  #                     },
  #                     preload: [
  #                       private_event_participation: [private_event: [:consumer, :place, private_event_participations: [:consumer], private_event_invitations: [:consumer]]]
  #                     ]
  #                   )
  #
  #       assert called NotificationChannel.new_reminder_created(reminder)
  #
  #       host = invitation.private_event.consumer
  #       assert called SendPushNotification.call(%{type: "accepted_private_event_invitation", host: host, private_event_invitation: invitation})
  #     end
  #   end
  # end

  defp expected_render(invitation) do
    %{
      id: invitation.id,
      private_event_id: invitation.private_event_id,
      consumer_id: invitation.consumer_id,
      state: invitation.state,
      consumer: %{
        id: invitation.consumer.id,
        name: invitation.consumer.name,
        about_me: invitation.consumer.about_me,
        fb_user_id: invitation.consumer.fb_user_id,
        inserted_at: Ecto.DateTime.to_iso8601(invitation.consumer.inserted_at),
        updated_at: Ecto.DateTime.to_iso8601(invitation.consumer.inserted_at),
      },
      private_event: %{
          id: invitation.private_event.id,
          name: invitation.private_event.name,
          host: invitation.private_event.consumer |> _render_consumer,
          place: %{
            id: invitation.private_event.place.id,
            name: invitation.private_event.place.name,
            website_url: invitation.private_event.place.website_url,
            contact_number: invitation.private_event.place.contact_number,
            location_address: invitation.private_event.place.location_address,
            is_featured: invitation.private_event.place.is_featured,
            description: invitation.private_event.place.description,
            image: invitation.private_event.place.image,
            lat: invitation.private_event.place.lat,
            long: invitation.private_event.place.long,
          },
          private_event_participations: invitation.private_event.private_event_participations |> Enum.map(&%{
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
          private_event_invitations: invitation.private_event.private_event_invitations |> Enum.map(&%{
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
          date: invitation.private_event.date |> _render_date,
          from: invitation.private_event.from |> _render_time,
          inserted_at: Ecto.DateTime.to_iso8601(invitation.private_event.inserted_at),
          updated_at: Ecto.DateTime.to_iso8601(invitation.private_event.inserted_at),
        },
      inserted_at: Ecto.DateTime.to_iso8601(invitation.inserted_at),
      updated_at: Ecto.DateTime.to_iso8601(invitation.inserted_at),
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
