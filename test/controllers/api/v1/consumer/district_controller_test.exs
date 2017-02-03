defmodule Playdays.Api.V1.Consumer.DistrictControllerTest do
  use Playdays.ConnCase, async: false
  import Playdays.Utils.MapUtils


  setup do
    conn = conn()
            |> put_req_header("accept", "application/json")

    district = create(:district, %{name: "A"})
    {:ok, conn: conn, district: district}
  end


  # test "list all districts", %{conn: conn, district: district} do
  #   conn = get conn, api_v1_consumer_district_path(conn, :index)
  #
  #   districts = [district]
  #
  #   expected_data = Enum.map(districts, fn(district) ->
  #                     %{
  #                       id: district.id,
  #                       name: district.name,
  #                       region_id: district.region_id,
  #                     }
  #                   end)
  #
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #   assert conn.status == 200
  #   assert response_data == expected_data
  # end

  # test "list all districts, sort_by name", %{conn: conn, district: district} do
  #   another_district = create(:district)
  #   districts = [district, another_district]
  #
  #   conn = get conn, api_v1_consumer_district_path(conn, :index)
  #
  #   expected_data = Enum.map(districts, fn(district) ->
  #                     %{
  #                       id: district.id,
  #                       name: district.name,
  #                       region_id: district.region_id,
  #                     }
  #                   end)
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #   first_district = hd response_data
  #   assert conn.status == 200
  #   assert response_data == expected_data
  #   assert first_district.name == "A"
  # end


end
