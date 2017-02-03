defmodule Playdays.Api.V1.Consumer.UserControllerTest do
  use Playdays.ConnCase, async: false
  import Playdays.Utils.MapUtils

  setup do
    consumer = create(:consumer)
    device = hd(consumer.devices)

    conn = conn()
            |> put_req_header("accept", "application/json")
            |> put_req_header("x-fb-user-id", consumer.fb_user_id)
            |> put_req_header("x-device-uuid", device.uuid)
            |> put_req_header("x-fb-access-token", device.fb_access_token)

    {:ok, conn: conn, consumer: consumer}
  end

  # test "search user with name", %{conn: conn} do
  #   user = create(:consumer, %{name: "Mr. Eulah Farrell"})
  #   create_list(2, :consumer)
  #
  #   data = %{
  #     name: "eula"
  #   }
  #   conn = get conn, api_v1_consumer_user_path(conn, :index), data
  #
  #   expected_data = [
  #                     %{
  #                       id: user.id,
  #                       fb_user_id: user.fb_user_id,
  #                       name: user.name,
  #                       about_me: user.about_me,
  #                       children: [
  #                         %{
  #                           id: hd(user.children).id,
  #                           birthday: hd(user.children).birthday
  #                         }
  #                       ],
  #                       region: %{
  #                         id: user.region.id,
  #                         name: user.region.name
  #                       },
  #                       district: %{
  #                         id: user.district.id,
  #                         name: user.district.name,
  #                         region_id: user.district.region_id
  #                       },
  #                     }
  #                   ]
  #
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #   assert conn.status == 200
  #   assert response_data == expected_data
  # end

  # test "test search user with name with full text searching", %{conn: conn} do
  #   user = create(:consumer, %{name: "Mr. Eulah Farrell"})
  #   create_list(2, :consumer)
  #
  #   data = %{
  #     name: "eulah farrrll"
  #   }
  #   conn = get conn, api_v1_consumer_user_path(conn, :index), data
  #
  #   expected_data = [
  #                     %{
  #                       id: user.id,
  #                       fb_user_id: user.fb_user_id,
  #                       name: user.name,
  #                       about_me: user.about_me,
  #                       children: [
  #                         %{
  #                           id: hd(user.children).id,
  #                           birthday: hd(user.children).birthday
  #                         }
  #                       ],
  #                       region: %{
  #                         id: user.region.id,
  #                         name: user.region.name
  #                       },
  #                       district: %{
  #                         id: user.district.id,
  #                         name: user.district.name,
  #                         region_id: user.district.region_id
  #                       },
  #                     }
  #                   ]
  #
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #   assert conn.status == 200
  #   assert response_data == expected_data
  # end
end
