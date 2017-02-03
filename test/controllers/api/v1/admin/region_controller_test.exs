defmodule Playdays.Api.V1.Admin.RegionControllerTest do
  use Playdays.ConnCase, async: false

  import Playdays.Utils.MapUtils


  setup do
    admin = create(:admin)
    conn = conn()
            |> put_req_header("accept", "application/json")
            |> put_req_header("x-auth-token", admin.authentication_token)

    regions = create_list(3, :region)
    region = hd regions
    {:ok, conn: conn, regions: regions, region: region}
  end


  test "list all regions", %{conn: conn} do
    conn = get conn, api_v1_admin_region_path(conn, :index)

    regions = conn.assigns.regions

    expected_data = Enum.map(regions, fn(region) ->
                      %{
                        id: region.id,
                        name: region.name,
                        hex_color_code: region.hex_color_code,
                      }
                    end)

    response_data = json_response(conn, 200)["data"] |> to_atom_keys
    assert conn.status == 200
    assert response_data == expected_data
  end

  test "show a region", %{conn: conn, region: region} do
    conn = get(conn, api_v1_admin_region_path(conn, :show, region))

    expected_data = %{
                      id: region.id,
                      name: region.name,
                      hex_color_code: region.hex_color_code,
                    }
    response_data = json_response(conn, 200)["data"] |> to_atom_keys
    assert conn.status == 200
    assert response_data == expected_data
  end

end
