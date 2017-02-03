defmodule Playdays.Test.Services.Admin.Place.CreatePlaceTest do
  use Playdays.ModelCase

  alias Playdays.Services.Admin.Place.CreatePlace

  setup do
    place = create(:place)
    categories = create_list(2, :category)
    tags = create_list(2, :tag)
    districts = create_list(2, :district)
    {:ok, place: place, categories: categories, tags: tags, districts: districts}
  end

  test "create place", %{categories: categories, tags: tags, districts: districts} do
    selected_categories_id = categories |> Enum.map(fn(c) -> c.id end)
    selected_tags_id = tags |> Enum.map(fn(t) -> t.id end)
    selected_districts_id = districts |> Enum.map(fn(t) -> t.id end)
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
      lat: "tet",
      long: "~",
    }
    { status, place } = CreatePlace.call(params)
    place = place |> Repo.preload([:categories, :tags])
    category_count = length place.categories
    tags_count = length place.tags
    assert status == :ok
    assert category_count == 2
    assert tags_count == 2
  end

  test "create place with empty name should return {:error, reason}" do
    { status, _} = CreatePlace.call(%{name: ""})
    assert status == :error
  end

  test "update place with exists namn should return {:error, reason}", %{place: place} do
    { status, _} = CreatePlace.call(%{name: place.name})
    assert status == :error
  end

end
