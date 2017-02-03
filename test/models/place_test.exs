defmodule Playdays.PlaceTest do
  use Playdays.ModelCase, async: false

  alias Playdays.Place

  @valid_attrs %{
    name: "place name",
    website_url: "www.letter-land.com",
    contact_number: "+85298881111",
    location_address: "7/F, Will Strong Development Building No. 59 Parkes Street, Kowloon",
    description: "description",
    image: "no.image.com",
    lat: "test",
    long: "test",
  }
  @invalid_attrs %{
    website_url: "www.letter-land.com",
    contact_number: "+85298881111",
    location_address: "7/F, Will Strong Development Building No. 59 Parkes Street, Kowloon",
    description: "description",
    image: "no.image.com"
  }

  test "changeset with valid attributes" do
    changeset = Place.changeset(%Place{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Place.changeset(%Place{}, @invalid_attrs)
    refute changeset.valid?
  end


  test "insert place with same name should raise error" do
    place = create(:place, name: "place_name1")

    assert_raise Ecto.ConstraintError, fn ->
      %Place{
        name: place.name,
      } |> Repo.insert!
    end
  end

  test "insert admin with empty name should raise InvalidChangesetError" do
    assert_raise Ecto.InvalidChangesetError, fn ->
      %Place{}
      |> Place.changeset(%{
        email: "",
        hashed_password: "PLAINPASSWORD",
      })
      |> Repo.insert!
    end
  end

  test "insert category" do
    place = create(:place) |> Repo.preload(:categories)
    category = create(:category)

    categories = place.categories ++ [category]
    categories_changeset = Enum.map(categories, &Ecto.Changeset.change/1)
    { status, place } = place
                            |> Ecto.Changeset.change
                            |> Ecto.Changeset.put_assoc(:categories, categories_changeset)
                            |> Repo.update

    categories_count = length place.categories
    assert status == :ok
    assert place.categories
    assert categories_count == 1
  end

  test "insert additional category" do
    place = create(:place) |> Repo.preload(:categories)
    category = create(:category)

    categories = place.categories ++ [category]
    categories_changeset = Enum.map(categories, &Ecto.Changeset.change/1)
    { :ok, place } = place
                            |> Ecto.Changeset.change
                            |> Ecto.Changeset.put_assoc(:categories, categories_changeset)
                            |> Repo.update


    additional_category = create(:category)

    updated_categories = place.categories ++ [additional_category]
    updated_categories_changeset = Enum.map(updated_categories, &Ecto.Changeset.change/1)
    { status, updated_place } = place
                                |> Ecto.Changeset.change
                                |> Ecto.Changeset.put_assoc(:categories, updated_categories_changeset)
                                |> Repo.update

    categories_count = length updated_place.categories
    assert status == :ok
    assert updated_place.categories
    assert categories_count == 2
  end

  test "cannot insert same category" do
    place = create(:place) |> Repo.preload(:categories)
    category = create(:category)

    categories = place.categories ++ [category]
    categories_changeset = Enum.map(categories, &Ecto.Changeset.change/1)
    { :ok, place } = place
                            |> Ecto.Changeset.change
                            |> Ecto.Changeset.put_assoc(:categories, categories_changeset)
                            |> Repo.update

    updated_categories = place.categories ++ [category]
    updated_categories_changeset = Enum.map(updated_categories, &Ecto.Changeset.change/1)
    { _status, updated_place } = place
                                |> Ecto.Changeset.change
                                |> Ecto.Changeset.put_assoc(:categories, updated_categories_changeset)
                                |> Repo.update
    updated_place = Repo.get_by!(Place, id: updated_place.id) |> Repo.preload(:categories)
    categories_count = length updated_place.categories
    assert updated_place.categories
    assert categories_count == 1
  end

  test "remove a category" do
    place = create(:place) |> Repo.preload(:categories)
    category = create(:category)
    additional_category = create(:category)

    categories = [category, additional_category]
    categories_changeset = Enum.map(categories, &Ecto.Changeset.change/1)
    { :ok, place } = place
                            |> Ecto.Changeset.change
                            |> Ecto.Changeset.put_assoc(:categories, categories_changeset)
                            |> Repo.update

    updated_categories = [hd(categories)]
    updated_categories_changeset = Enum.map(updated_categories, &Ecto.Changeset.change/1)
    { status, updated_place } = place
                                |> Ecto.Changeset.change
                                |> Ecto.Changeset.put_assoc(:categories, updated_categories_changeset)
                                |> Repo.update

    categories_count = length updated_place.categories
    assert status == :ok
    assert updated_place.categories
    assert categories_count == 1
  end

  test "insert district" do
    place = create(:place) |> Repo.preload(:districts)
    district = create(:district)

    districts = place.districts ++ [district]
    districts_changeset = Enum.map(districts, &Ecto.Changeset.change/1)
    { status, place } = place
                            |> Ecto.Changeset.change
                            |> Ecto.Changeset.put_assoc(:districts, districts_changeset)
                            |> Repo.update

    districts_count = length place.districts
    assert status == :ok
    assert place.districts
    assert districts_count == 1
  end

  test "insert additional district" do
    place = create(:place) |> Repo.preload(:districts)
    district = create(:district)

    districts = place.districts ++ [district]
    districts_changeset = Enum.map(districts, &Ecto.Changeset.change/1)
    { :ok, place } = place
                            |> Ecto.Changeset.change
                            |> Ecto.Changeset.put_assoc(:districts, districts_changeset)
                            |> Repo.update


    additional_district = create(:district)

    updated_districts = place.districts ++ [additional_district]
    updated_districts_changeset = Enum.map(updated_districts, &Ecto.Changeset.change/1)
    { status, updated_place } = place
                                |> Ecto.Changeset.change
                                |> Ecto.Changeset.put_assoc(:districts, updated_districts_changeset)
                                |> Repo.update

    districts_count = length updated_place.districts
    assert status == :ok
    assert updated_place.districts
    assert districts_count == 2
  end

  test "cannot insert same district" do
    place = create(:place) |> Repo.preload(:districts)
    district = create(:district)

    districts = place.districts ++ [district]
    districts_changeset = Enum.map(districts, &Ecto.Changeset.change/1)
    { :ok, place } = place
                            |> Ecto.Changeset.change
                            |> Ecto.Changeset.put_assoc(:districts, districts_changeset)
                            |> Repo.update

    updated_districts = place.districts ++ [district]
    updated_districts_changeset = Enum.map(updated_districts, &Ecto.Changeset.change/1)
    { _status, updated_place } = place
                                |> Ecto.Changeset.change
                                |> Ecto.Changeset.put_assoc(:districts, updated_districts_changeset)
                                |> Repo.update
    updated_place = Repo.get_by!(Place, id: updated_place.id) |> Repo.preload(:districts)
    districts_count = length updated_place.districts
    assert updated_place.districts
    assert districts_count == 1
  end

  test "remove a district" do
    place = create(:place) |> Repo.preload(:districts)
    district = create(:district)
    additional_district = create(:district)

    districts = [district, additional_district]
    districts_changeset = Enum.map(districts, &Ecto.Changeset.change/1)
    { :ok, place } = place
                            |> Ecto.Changeset.change
                            |> Ecto.Changeset.put_assoc(:districts, districts_changeset)
                            |> Repo.update

    updated_districts = [hd(districts)]
    updated_districts_changeset = Enum.map(updated_districts, &Ecto.Changeset.change/1)
    { status, updated_place } = place
                                |> Ecto.Changeset.change
                                |> Ecto.Changeset.put_assoc(:districts, updated_districts_changeset)
                                |> Repo.update

    districts_count = length updated_place.districts
    assert status == :ok
    assert updated_place.districts
    assert districts_count == 1
  end

  test "insert tag" do
    place = create(:place) |> Repo.preload(:tags)
    tag = create(:tag)

    tags = place.tags ++ [tag]
    tags_changeset = Enum.map(tags, &Ecto.Changeset.change/1)
    { status, place } = place
                            |> Ecto.Changeset.change
                            |> Ecto.Changeset.put_assoc(:tags, tags_changeset)
                            |> Repo.update

    tags_count = length place.tags
    assert status == :ok
    assert place.tags
    assert tags_count == 1
  end

  test "insert additional tag" do
    place = create(:place) |> Repo.preload(:tags)
    tag = create(:tag)

    tags = place.tags ++ [tag]
    tags_changeset = Enum.map(tags, &Ecto.Changeset.change/1)
    { :ok, place } = place
                            |> Ecto.Changeset.change
                            |> Ecto.Changeset.put_assoc(:tags, tags_changeset)
                            |> Repo.update


    additional_tag = create(:tag)

    updated_tags = place.tags ++ [additional_tag]
    updated_tags_changeset = Enum.map(updated_tags, &Ecto.Changeset.change/1)
    { status, updated_place } = place
                                |> Ecto.Changeset.change
                                |> Ecto.Changeset.put_assoc(:tags, updated_tags_changeset)
                                |> Repo.update

    tags_count = length updated_place.tags
    assert status == :ok
    assert updated_place.tags
    assert tags_count == 2
  end

  test "cannot insert same tag" do
    place = create(:place) |> Repo.preload(:tags)
    tag = create(:tag)

    tags = place.tags ++ [tag]
    tags_changeset = Enum.map(tags, &Ecto.Changeset.change/1)
    { :ok, place } = place
                            |> Ecto.Changeset.change
                            |> Ecto.Changeset.put_assoc(:tags, tags_changeset)
                            |> Repo.update

    updated_tags = place.tags ++ [tag]
    updated_tags_changeset = Enum.map(updated_tags, &Ecto.Changeset.change/1)
    { _status, updated_place } = place
                                |> Ecto.Changeset.change
                                |> Ecto.Changeset.put_assoc(:tags, updated_tags_changeset)
                                |> Repo.update
    updated_place = Repo.get_by!(Place, id: updated_place.id) |> Repo.preload(:tags)
    tags_count = length updated_place.tags
    assert updated_place.tags
    assert tags_count == 1
  end

  test "remove a tag" do
    place = create(:place) |> Repo.preload(:tags)
    tag = create(:tag)
    additional_tag = create(:category)

    tags = [tag, additional_tag]
    tags_changeset = Enum.map(tags, &Ecto.Changeset.change/1)
    { :ok, place } = place
                      |> Ecto.Changeset.change
                      |> Ecto.Changeset.put_assoc(:tags, tags_changeset)
                      |> Repo.update

    updated_tags = [hd(tags)]
    updated_tags_changeset = Enum.map(updated_tags, &Ecto.Changeset.change/1)
    { status, updated_place } = place
                                |> Ecto.Changeset.change
                                |> Ecto.Changeset.put_assoc(:tags, updated_tags_changeset)
                                |> Repo.update

    tags_count = length updated_place.tags
    assert status == :ok
    assert updated_place.tags
    assert tags_count == 1
  end
end
