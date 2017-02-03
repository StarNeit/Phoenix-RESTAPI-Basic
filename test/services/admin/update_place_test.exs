defmodule Playdays.Test.Services.Admin.Place.UpdatePlaceTest do
  use Playdays.ModelCase

  alias Playdays.Services.Admin.Place.UpdatePlace

  setup do
    places = create_list(2, :place)
    categories = create_list(2, :category)
    tags = create_list(2, :tag)
    districts = create_list(2, :district)

    {:ok, places: places, categories: categories, tags: tags, districts: districts}
  end

  test "update place with new name", %{places: [place1, _], categories: categories, tags: tags, districts: districts} do
    selected_categories_id = categories |> Enum.map(fn(c) -> c.id end)
    selected_tags_id = tags |> Enum.map(fn(t) -> t.id end)
    selected_districts_id = districts |> Enum.map(fn(t) -> t.id end)
    place1 = place1 |> Repo.preload([:categories, :tags, :districts])
    params = %{
      name: "#{Faker.Company.name} #{Faker.Company.bullshit}",
      website_url: Faker.Internet.domain_name,
      contact_number: "+85298881111",
      location_address: Faker.Address.street_address,
      description: Faker.Lorem.paragraphs(5) |> Enum.join,
      selected_categories_id: selected_categories_id,
      selected_tags_id: selected_tags_id,
      selected_districts_id: selected_districts_id,
      image: "no.image.com",
      lat: "test",
      long: "test", 
    }

    {status, place} = UpdatePlace.call(place1, params)
    category_count = length place.categories
    tags_count = length place.tags
    assert status == :ok
    assert category_count == 2
    assert tags_count == 2
  end

  test "update place with empty name should return {:error, reason}", %{places: [place1, _]} do
    place1 = place1 |> Repo.preload([:categories, :tags, :districts])
    {:error, _} = UpdatePlace.call(place1, %{name: ""})
  end

  test "update place with exists namn should return {:error, reason}", %{places: [place1, place2]} do
    place1 = place1 |> Repo.preload([:categories, :tags, :districts])
    {:error, _} = UpdatePlace.call(place1, %{name: place2.name})
  end

end
