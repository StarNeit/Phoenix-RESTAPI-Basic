defmodule Playdays.Api.V1.Consumer.RegionControllerTest do
  use Playdays.ConnCase, async: false
  import Playdays.Utils.MapUtils


  setup do
    conn = conn()
            |> put_req_header("accept", "application/json")

    region = create(:region, %{name: "A"})
    {:ok, conn: conn, region: region}
  end


  # test "list all regions", %{conn: conn, region: region} do
  #   conn = get conn, api_v1_consumer_region_path(conn, :index)
  #
  #   regions = [region]
  #
  #   expected_data = Enum.map(regions, fn(region) ->
  #                     %{
  #                       id: region.id,
  #                       name: region.name,
  #                       districts: [],
  #                     }
  #                   end)
  #
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #   assert conn.status == 200
  #   assert response_data == expected_data
  # end

  # test "list all regions, sort_by name", %{conn: conn, region: region} do
  #   another_region = create(:region)
  #   regions = [region, another_region]
  #
  #   conn = get conn, api_v1_consumer_region_path(conn, :index)
  #
  #   expected_data = Enum.map(regions, fn(region) ->
  #                     %{
  #                       id: region.id,
  #                       name: region.name,
  #                       districts: [],
  #                     }
  #                   end)
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #   first_region = hd response_data
  #   assert conn.status == 200
  #   assert response_data == expected_data
  #   assert first_region.name == "A"
  # end


end
