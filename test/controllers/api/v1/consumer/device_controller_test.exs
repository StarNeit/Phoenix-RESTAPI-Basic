defmodule Playdays.Api.V1.Consumer.DeviceControllerTest do
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

    {:ok, conn: conn, consumer: consumer, device: device}
  end

  # test "update device", %{conn: conn, device: device} do
  #   data = %{
  #     device_token: "fake_device_token",
  #     platform: "ios"
  #   }
  #   conn = put(conn, api_v1_consumer_device_path(conn, :update, device.uuid), data)
  #   assert conn.status == 200
  #   expected_data = conn.assigns.updated_device |> _render_show
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #   assert response_data == expected_data
  # end

  defp _render_show(device) do
    %{
      fb_access_token: device.fb_access_token,
      uuid: device.uuid
    }
  end

end
