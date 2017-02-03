defmodule Playdays.Api.V1.Admin.DistrictControllerTest do
  use Playdays.ConnCase, async: false

  import Playdays.Utils.MapUtils


  setup do
    admin = create(:admin)
    conn = conn()
            |> put_req_header("accept", "application/json")
            |> put_req_header("x-auth-token", admin.authentication_token)
    region = create(:region)
    districts = create_list(3, :district, %{region: region})
    district = hd districts
    {:ok, conn: conn, districts: districts, district: district}
  end


  test "list all districts", %{conn: conn} do
    conn = get conn, api_v1_admin_district_path(conn, :index)

    districts = conn.assigns.districts

    expected_data = Enum.map(districts, fn(district) ->
                      %{
                        id: district.id,
                        name: district.name,
                        hex_color_code: district.hex_color_code,
                        region_id: district.region_id,
                        region: %{
                          id: district.region.id,
                          name: district.region.name,
                          hex_color_code: district.region.hex_color_code,
                        }
                      }
                    end)

    response_data = json_response(conn, 200)["data"] |> to_atom_keys
    assert conn.status == 200
    assert response_data == expected_data
  end

  test "show a district", %{conn: conn, district: district} do
    conn = get(conn, api_v1_admin_district_path(conn, :show, district))

    expected_data = %{
                      id: district.id,
                      name: district.name,
                      hex_color_code: district.hex_color_code,
                      region_id: district.region_id,
                      region: %{
                        id: district.region.id,
                        name: district.region.name,
                        hex_color_code: district.region.hex_color_code,
                      }
                    }
    response_data = json_response(conn, 200)["data"] |> to_atom_keys
    assert conn.status == 200
    assert response_data == expected_data
  end

end
