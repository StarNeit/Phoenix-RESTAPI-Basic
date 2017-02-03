defmodule Playdays.Api.V1.Consumer.PlaceControllerTest do
  use Playdays.ConnCase, async: false

  # import Mock

  import Playdays.Utils.MapUtils


  setup do
    conn = conn()
            |> put_req_header("accept", "application/json")

    place = create(:place, %{name: "A"})
    {:ok, conn: conn, place: place}
  end


  # test "list all places", %{conn: conn, place: place} do
  #   conn = get conn, api_v1_consumer_place_path(conn, :index)
  #
  #   places = [place]
  #
  #   expected_data = Enum.map(places, fn(place) ->
  #                     %{
  #                       id: place.id,
  #                       name: place.name,
  #                       website_url: place.website_url,
  #                       contact_number: place.contact_number,
  #                       location_address: place.location_address,
  #                       is_featured: place.is_featured,
  #                       description: place.description,
  #                       lat: place.lat,
  #                       long: place.long,
  #                       image: place.image,
  #                       tags: [],
  #                       categories: [],
  #                       districts: [],
  #                     }
  #                   end)
  #
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #   assert conn.status == 200
  #   assert response_data == expected_data
  # end

  # test "list all places, sort_by name", %{conn: conn, place: place} do
  #   another_place = create(:place)
  #   places = [place, another_place]
  #
  #   conn = get conn, api_v1_consumer_place_path(conn, :index)
  #
  #   expected_data = Enum.map(places, fn(place) ->
  #                     %{
  #                       id: place.id,
  #                       name: place.name,
  #                       website_url: place.website_url,
  #                       contact_number: place.contact_number,
  #                       location_address: place.location_address,
  #                       description: place.description,
  #                       image: place.image,
  #                       is_featured: place.is_featured,
  #                       lat: place.lat,
  #                       long: place.long,
  #                       tags: [],
  #                       categories: [],
  #                       districts: [],
  #                     }
  #                   end)
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #   first_place = hd response_data
  #   assert conn.status == 200
  #   assert response_data == expected_data
  #   assert first_place.name == "A"
  # end

  test "show a place", %{conn: conn, place: place} do
    conn = get(conn, api_v1_consumer_place_path(conn, :show, place))

    expected_data = %{
                      id: place.id,
                      name: place.name,
                      website_url: place.website_url,
                      contact_number: place.contact_number,
                      location_address: place.location_address,
                      description: place.description,
                      is_featured: place.is_featured,
                      image: place.image,
                      lat: place.lat,
                      long: place.long,
                    }
    response_data = json_response(conn, 200)["data"] |> to_atom_keys
    assert conn.status == 200
    assert response_data == expected_data
  end

end
