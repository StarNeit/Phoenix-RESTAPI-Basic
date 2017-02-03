defmodule Playdays.Api.V1.Consumer.FriendRequestControllerTest do
  use Playdays.ConnCase, async: false

  import Mock
  import Playdays.Utils.MapUtils

  alias Playdays.Consumer
  alias Playdays.Consumer.NotificationChannel
  alias Playdays.Queries.ReminderQuery
  alias Playdays.Services.Consumer.FriendRequest.CreateFriendRequest
  alias Playdays.Services.Consumer.PushNotification.SendPushNotification

  setup do
    consumer = create(:consumer) |> Repo.preload(:friends)
    another_consumer = create(:consumer) |> Repo.preload(:friends)
    consumer |> Consumer.add_friend(another_consumer) |> Repo.update!
    another_consumer |> Consumer.add_friend(consumer) |> Repo.update!
    device = hd(consumer.devices)

    conn = conn()
            |> put_req_header("accept", "application/json")
            |> put_req_header("x-fb-user-id", consumer.fb_user_id)
            |> put_req_header("x-device-uuid", device.uuid)
            |> put_req_header("x-fb-access-token", device.fb_access_token)

    {:ok, conn: conn, consumer: consumer, another_consumer: another_consumer}
  end

  # test "list all current consumer friend requests", %{conn: conn, consumer: consumer, another_consumer: another_consumer} do
  #   { :ok, {outbound_friend_reqeust, _reminder} } = CreateFriendRequest.call(%{requester: consumer, requestee: another_consumer})
  #   { :ok, {inbound_friend_reqeust, _reminder} } = CreateFriendRequest.call(%{requester: another_consumer, requestee: consumer})
  #   inbound_friend_reqeust = inbound_friend_reqeust |> Repo.preload([requester: [:region, :district]])
  #   conn = get conn, api_v1_consumer_friend_request_path(conn, :index)
  #
  #   expected_data = [
  #     %{
  #       id: outbound_friend_reqeust.id,
  #       requestee_id: outbound_friend_reqeust.requestee_id,
  #       requester_id: outbound_friend_reqeust.requester_id,
  #       state: outbound_friend_reqeust.state,
  #     },
  #     %{
  #       id: inbound_friend_reqeust.id,
  #       requester_id: another_consumer.id,
  #       requestee_id: consumer.id,
  #       state: inbound_friend_reqeust.state,
  #       requester: %{
  #         id: another_consumer.id,
  #         name: another_consumer.name,
  #         about_me: another_consumer.about_me,
  #         region: %{
  #           id: another_consumer.region.id,
  #           name: another_consumer.region.name,
  #         },
  #         district: %{
  #           id: another_consumer.district.id,
  #           name: another_consumer.district.name,
  #           region_id: another_consumer.district.region_id
  #         },
  #         fb_user_id: another_consumer.fb_user_id,
  #         children: [
  #           %{
  #             id: hd(another_consumer.children).id,
  #             birthday: hd(another_consumer.children).birthday
  #           }
  #         ]
  #       },
  #     }
  #   ]
  #
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #   assert conn.status == 200
  #   assert response_data == expected_data
  # end

  # test "create a friend request", %{conn: conn, consumer: consumer, another_consumer: another_consumer} do
  #   with_mock SendPushNotification, [call: fn(_) -> end] do
  #     data = %{
  #       requestee_id: another_consumer.id
  #     }
  #
  #     conn = post(conn, api_v1_consumer_friend_request_path(conn, :create), data)
  #
  #     response_data = json_response(conn, 201)["data"] |> to_atom_keys
  #
  #     new_friend_request = conn.assigns.new_friend_request |> Repo.preload(:requester)
  #     expected_data = %{
  #         id: new_friend_request.id,
  #         requestee_id: new_friend_request.requestee_id,
  #         requester: %{
  #           id: new_friend_request.requester.id,
  #           fb_user_id: new_friend_request.requester.fb_user_id,
  #           name: new_friend_request.requester.name,
  #           about_me: new_friend_request.requester.about_me,
  #           children: [
  #             %{
  #               id: hd(new_friend_request.requester.children).id,
  #               birthday: hd(new_friend_request.requester.children).birthday
  #             }
  #           ]
  #         },
  #         requester_id: new_friend_request.requester_id,
  #         state: new_friend_request.state,
  #       }
  #
  #     assert conn.status == 201
  #     assert response_data == expected_data
  #     requester = conn.assigns.current_consumer
  #     requestee = conn.assigns.current_requestee
  #     assert called SendPushNotification.call(%{type: "new_friend_request", requestee: requestee, requester: requester})
  #   end
  # end

  # test "accpet a friend request", %{conn: conn, consumer: consumer, another_consumer: another_consumer} do
  #   with_mock SendPushNotification, [call: fn(_) -> end] do
  #     { :ok, {inbound_friend_reqeust, _reminder} } = CreateFriendRequest.call(%{requester: another_consumer, requestee: consumer})
  #
  #     data = %{
  #       requester_id: another_consumer.id,
  #       action_type: "accept",
  #     }
  #
  #     conn = put(conn, api_v1_consumer_friend_request_path(conn, :update, inbound_friend_reqeust), data)
  #
  #     response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #
  #     updated_friend_request = conn.assigns.updated_friend_request |> Repo.preload(:requestee)
  #     expected_data = %{
  #         id: updated_friend_request.id,
  #         requestee_id: updated_friend_request.requestee_id,
  #         requester_id: updated_friend_request.requester_id,
  #         requestee: %{
  #           id: updated_friend_request.requestee.id,
  #           fb_user_id: updated_friend_request.requestee.fb_user_id,
  #           name: updated_friend_request.requestee.name,
  #           about_me: updated_friend_request.requestee.about_me,
  #           children: [
  #             %{
  #               id: hd(updated_friend_request.requestee.children).id,
  #               birthday: hd(updated_friend_request.requestee.children).birthday
  #             }
  #           ]
  #         },
  #         state: updated_friend_request.state,
  #       }
  #
  #     assert conn.status == 200
  #     assert response_data == expected_data
  #
  #     requester = conn.assigns.current_requester
  #     requestee = conn.assigns.current_consumer
  #
  #     assert called SendPushNotification.call(%{type: "accepted_friend_request", requestee: requestee, requester: requester})
  #   end
  # end

  # test "create a friend request will notify consumer new reminder", %{conn: conn, another_consumer: another_consumer} do
  #   with_mock NotificationChannel, mocked_notification_channel_func_list do
  #     data = %{
  #       requestee_id: another_consumer.id
  #     }
  #
  #     post(conn, api_v1_consumer_friend_request_path(conn, :create), data)
  #
  #     payload = ReminderQuery.find_one(
  #       %{consumer_id: another_consumer.id},
  #       preload: [friend_request: [:requester]]
  #     )
  #
  #     assert called NotificationChannel.new_reminder_created(payload)
  #   end
  # end

  # test "accpet a friend request will notify consumer new reminder", %{conn: conn, consumer: consumer, another_consumer: another_consumer} do
  #   with_mock NotificationChannel, mocked_notification_channel_func_list do
  #     { :ok, {inbound_friend_reqeust, reminder} } = CreateFriendRequest.call(%{requester: another_consumer, requestee: consumer})
  #
  #     data = %{
  #       requester_id: another_consumer.id,
  #       action_type: "accept"
  #     }
  #
  #     put(conn, api_v1_consumer_friend_request_path(conn, :update, inbound_friend_reqeust), data)
  #
  #     payload = ReminderQuery.find_one(
  #       %{
  #         consumer_id: another_consumer.id,
  #         reminder_type: "acceptedFriendRequestReminder"
  #       },
  #       preload: [friend_request: [:requestee]]
  #     )
  #
  #     assert called NotificationChannel.new_reminder_created(payload)
  #   end
  # end

  defp mocked_notification_channel_func_list() do
    [
      new_friend_request_created: fn(_) -> {:ok, "things"} end,
      friend_request_accepted: fn(_) -> {:ok, "things"} end,
      new_reminder_created: fn(_) -> {:ok, "things"} end
    ]
  end

end
