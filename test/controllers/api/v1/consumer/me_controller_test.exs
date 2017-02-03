defmodule Playdays.Api.V1.Consumer.MeControllerTest do
  use Playdays.ConnCase, async: false
  import Playdays.Utils.MapUtils

  alias Playdays.SecureRandom

  @valid_update_attrs %{
    email: Faker.Internet.email,
    name: Faker.Name.name,
    about_me: Faker.Lorem.paragraphs() |> hd,
    mobile_phone_number: "90293021",
    children: [
      %{birthday: "2015-0" <> SecureRandom.numeric(1)}
    ]
  }

  setup do
    me = create(:consumer)
    device = hd(me.devices)

    conn = conn()
            |> put_req_header("accept", "application/json")
            |> put_req_header("x-fb-user-id", me.fb_user_id)
            |> put_req_header("x-device-uuid", device.uuid)
            |> put_req_header("x-fb-access-token", device.fb_access_token)

    {:ok, conn: conn, me: me}
  end

  # test "show me", %{conn: conn, me: me} do
  #   conn = get conn, api_v1_consumer_me_path(conn, :show)
  #
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #   assert response_data == expected_render me
  # end

  # test "update me", %{conn: conn, me: me} do
  #   conn = put conn, api_v1_consumer_me_path(conn, :show), @valid_update_attrs
  #
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #   assert response_data == me |> Map.merge(@valid_update_attrs) |> expected_render(response_data)
  # end

  defp expected_render(me, response_data \\ nil) do
    me = Repo.preload me, [:friends]
    result = %{
      id: me.id,
      name: me.name,
      email: me.email,
      about_me: me.about_me,
      fb_user_id: me.fb_user_id,
      languages: me.languages,
      mobile_phone_number: me.mobile_phone_number,
      device: %{
        uuid: hd(me.devices).uuid,
        fb_access_token: hd(me.devices).fb_access_token,
      },
      region: %{
        name: me.region.name,
        id: me.region.id,
      },
      district: %{
        id: me.district.id,
        name: me.district.name,
        region_id: me.district.region_id,
      },
      friends_count: length me.friends
    }

    if response_data do
      assert Enum.map(response_data.children, &Map.take(&1, [:birthday])) == me.children
      Map.put(result, :children, response_data.children)
    else
      Map.put(result, :children, Enum.map(
        me.children,
        &%{id: &1.id, birthday: &1.birthday}
      ))
    end
  end

end
