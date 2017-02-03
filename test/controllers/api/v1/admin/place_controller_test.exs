  defmodule Playdays.Api.V1.Admin.PlaceControllerTest do
  use Playdays.ConnCase, async: false

  # import Mock

  import Playdays.Utils.MapUtils

  setup do
    admin = create(:admin)
    conn = conn()
            |> put_req_header("accept", "application/json")
            |> put_req_header("x-auth-token", admin.authentication_token)

    place = create(:place, %{name: "A"})
    {:ok, conn: conn, place: place}
  end

  # test "list all places", %{conn: conn, place: place} do
  #   conn = get conn, api_v1_admin_place_path(conn, :index)
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
  #                       description: place.description,
  #                       categories: [],
  #                       tags: [],
  #                       districts: [],
  #                       image: place.image,
  #                       is_active: place.is_active,
  #                       is_featured: place.is_featured,
  #                       lat: place.lat,
  #                       long: place.long,
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
  #   conn = get conn, api_v1_admin_place_path(conn, :index)
  #
  #   expected_data = Enum.map(places, fn(place) ->
  #                     %{
  #                       id: place.id,
  #                       name: place.name,
  #                       website_url: place.website_url,
  #                       contact_number: place.contact_number,
  #                       location_address: place.location_address,
  #                       description: place.description,
  #                       categories: [],
  #                       tags: [],
  #                       districts: [],
  #                       image: place.image,
  #                       is_active: place.is_active,
  #                       is_featured: place.is_featured,
  #                       lat: place.lat,
  #                       long: place.long,
  #                     }
  #                   end)
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #   first_place = hd response_data
  #   assert conn.status == 200
  #   assert response_data == expected_data
  #   assert first_place.name == "A"
  # end

  test "show a place", %{conn: conn, place: place} do
    conn = get(conn, api_v1_admin_place_path(conn, :show, place))

    expected_data = %{
                      id: place.id,
                      name: place.name,
                      website_url: place.website_url,
                      contact_number: place.contact_number,
                      location_address: place.location_address,
                      description: place.description,
                      categories: [],
                      tags: [],
                      districts: [],
                      image: place.image,
                      is_active: place.is_active,
                      is_featured: place.is_featured,
                      lat: place.lat,
                      long: place.long,
                    }
    response_data = json_response(conn, 200)["data"] |> to_atom_keys
    assert conn.status == 200
    assert response_data == expected_data
  end

  test "admin create place", %{conn: conn} do
    category = create(:category)
    tag = create(:tag)
    district = create(:district)
    data = %{
      name: "#{Faker.Company.name} #{Faker.Company.bullshit}",
      website_url: Faker.Internet.domain_name,
      contact_number: "+85298881111",
      location_address: Faker.Address.street_address,
      description: Faker.Lorem.paragraphs(5) |> Enum.join,
      selected_categories_id: [category.id],
      selected_tags_id: [tag.id],
      selected_districts_id: [district.id],
      image: "no.image.com",
      is_active: true,
      is_featured: false,
      lat: "test lat",
      long: "test long",
    }

    conn = post(conn, api_v1_admin_place_path(conn, :create), data)

    place = conn.assigns.new_place

    expected_data = %{
      id: place.id,
      name: place.name,
      website_url: place.website_url,
      contact_number: place.contact_number,
      location_address: place.location_address,
      description: place.description,
      image: place.image,
      is_active: place.is_active,
      is_featured: place.is_featured,
      lat: place.lat,
      long: place.long,
      categories: [
        %{
          id: category.id,
          title: category.title,
          hex_color_code: category.hex_color_code,
          image: category.image,
        }
      ],
      tags: [
        %{
          id: tag.id,
          title: tag.title
        }
      ],
      districts: [
        %{
          id: district.id,
          name: district.name,
          region_id: district.region_id,
          hex_color_code: district.hex_color_code,
          region: %{
            id: district.region.id,
            name: district.region.name,
            hex_color_code: district.region.hex_color_code,
          }
        }
      ],
    }

    response_data = json_response(conn, 201)["data"] |> to_atom_keys

    assert response_data == expected_data
  end

  test "admin cannot create place with empty name", %{conn: conn} do
    data = %{
      website_url: Faker.Internet.domain_name,
      contact_number: "+85298881111",
      location_address: Faker.Address.street_address,
      description: Faker.Lorem.paragraphs(5) |> Enum.join,
      image: "no.image.com",
      is_active: true,
      is_featured: false,
      lat: "test",
      long: "test",
    }

    conn = post(conn, api_v1_admin_place_path(conn, :create), data)
    assert_status(conn, 422)
  end

  test "admin update place", %{conn: conn, place: place} do
    category = create(:category)
    tag = create(:tag)
    district = create(:district)
    data =  %{
      name: "#{Faker.Company.name} #{Faker.Company.bullshit}",
      website_url: Faker.Internet.domain_name,
      contact_number: "+85298881111",
      location_address: Faker.Address.street_address,
      description: Faker.Lorem.paragraphs(5) |> Enum.join,
      selected_categories_id: [category.id],
      selected_tags_id: [tag.id],
      selected_districts_id: [district.id],
      image: "no.image.com",
      is_active: true,
      is_featured: false,
      lat: "~",
      long: "~~~~",
    }
    conn = put(conn, api_v1_admin_place_path(conn, :update, place), data)

    place = conn.assigns.updated_place

    expected_data = %{
      id: place.id,
      name: place.name,
      website_url: place.website_url,
      contact_number: place.contact_number,
      location_address: place.location_address,
      description: place.description,
      image: place.image,
      is_active: place.is_active,
      is_featured: place.is_featured,
      lat: "~",
      long: "~~~~",
      categories: [
        %{
          id: category.id,
          title: category.title,
          hex_color_code: category.hex_color_code,
          image: category.image
        }
      ],
      tags: [
        %{
          id: tag.id,
          title: tag.title
        }
      ],
      districts: [
        %{
          id: district.id,
          name: district.name,
          hex_color_code: district.hex_color_code,
          region: %{
            id: district.region.id,
            name: district.region.name,
            hex_color_code: district.region.hex_color_code,
          },
          region_id: district.region_id,
        }
      ],
    }

    response_data = json_response(conn, 200)["data"] |> to_atom_keys

    assert response_data == expected_data
  end

  test "admin update place with existing place name", %{conn: conn, place: place} do
    existing_place = create(:place)
    data = %{
      name: existing_place.name
    }
    conn = put(conn, api_v1_admin_place_path(conn, :update, place), data)

    assert_status(conn, 422)
  end

end
