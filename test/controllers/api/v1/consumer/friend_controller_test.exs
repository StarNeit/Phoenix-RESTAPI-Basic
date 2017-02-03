defmodule Playdays.Api.V1.Consumer.FriendControllerTest do
  use Playdays.ConnCase, async: false
  import Playdays.Utils.MapUtils

  alias Playdays.Consumer

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

  # test "list all current consumer friends", %{conn: conn, another_consumer: another_consumer} do
  #
  #   conn = get conn, api_v1_consumer_friend_path(conn, :index)
  #
  #   expected_data = [
  #                     %{
  #                       id: another_consumer.id,
  #                       fb_user_id: another_consumer.fb_user_id,
  #                       name: another_consumer.name,
  #                       about_me: another_consumer.about_me,
  #                       children: [
  #                         %{
  #                           id: hd(another_consumer.children).id,
  #                           birthday: hd(another_consumer.children).birthday
  #                         }
  #                       ],
  #                       region: %{
  #                         id: another_consumer.region.id,
  #                         name: another_consumer.region.name
  #                       },
  #                       district: %{
  #                         id: another_consumer.district.id,
  #                         name: another_consumer.district.name,
  #                         region_id: another_consumer.district.region_id
  #                       },
  #                       languages: another_consumer.languages
  #                     }
  #                   ]
  #
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #   assert conn.status == 200
  #   assert response_data == expected_data
  # end

  # test "show a friend", %{conn: conn, another_consumer: another_consumer} do
  #   conn = get(conn, api_v1_consumer_friend_path(conn, :show, another_consumer))
  #
  #   expected_data = %{
  #     id: another_consumer.id,
  #     fb_user_id: another_consumer.fb_user_id,
  #     name: another_consumer.name,
  #     about_me: another_consumer.about_me,
  #     children: [
  #       %{
  #         id: hd(another_consumer.children).id,
  #         birthday: hd(another_consumer.children).birthday
  #       }
  #     ],
  #     region: %{
  #       id: another_consumer.region.id,
  #       name: another_consumer.region.name
  #     },
  #     district: %{
  #       id: another_consumer.district.id,
  #       name: another_consumer.district.name,
  #       region_id: another_consumer.district.region_id
  #     },
  #     languages: another_consumer.languages,
  #   }
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #   assert conn.status == 200
  #   assert response_data == expected_data
  # end
end
