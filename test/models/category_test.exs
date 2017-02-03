defmodule Playdays.CategoryTest do
  use Playdays.ModelCase, async: true

  alias Playdays.Category

  @valid_attrs %{title: "category_1", hex_color_code: "#1", image: "image_url"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Category.changeset(%Category{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Category.changeset(%Category{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "insert category with same title should raise ConstraintError" do
    category = create(:category)

    assert_raise Ecto.ConstraintError, fn ->
      %Category{
        title: category.title
      } |> Repo.insert!
    end
  end

  test "insert category with empty title should raise InvalidChangesetError" do
    assert_raise Ecto.InvalidChangesetError, fn ->
      %Category{}
      |> Category.changeset(%{
            title: ""
          })
      |> Repo.insert!
    end
  end

  test "insert place to category" do
    category = create(:category)
    place = create(:place)

    category = category |> Repo.preload(:places)
    places = category.places ++ [place]
    places_changeset = Enum.map(places, &Ecto.Changeset.change/1)
    { status, category } = category
                            |> Ecto.Changeset.change
                            |> Ecto.Changeset.put_assoc(:places, places_changeset)
                            |> Repo.update

    place_count = length category.places
    assert status == :ok
    assert category.places
    assert place_count == 1
  end

  test "insert additional place to category" do
    category = create(:category)
    place = create(:place)

    category = category |> Repo.preload(:places)
    places = category.places ++ [place]
    places_changeset = Enum.map(places, &Ecto.Changeset.change/1)
    { :ok, category } = category
                            |> Ecto.Changeset.change
                            |> Ecto.Changeset.put_assoc(:places, places_changeset)
                            |> Repo.update

    additional_place = create(:place)
    updated_places = category.places ++ [additional_place]
    updated_places_changeset = Enum.map(updated_places, &Ecto.Changeset.change/1)
    { status, updated_category } = category
                                    |> Ecto.Changeset.change
                                    |> Ecto.Changeset.put_assoc(:places, updated_places_changeset)
                                    |> Repo.update

    place_count = length updated_category.places
    assert status == :ok
    assert updated_category.places
    assert place_count == 2
  end

  test "cannot insert same place" do
    category = create(:category)
    place = create(:place)

    category = category |> Repo.preload(:places)
    places = category.places ++ [place]
    places_changeset = Enum.map(places, &Ecto.Changeset.change/1)
    { :ok, category } = category
                            |> Ecto.Changeset.change
                            |> Ecto.Changeset.put_assoc(:places, places_changeset)
                            |> Repo.update

    updated_places = category.places ++ [place]
    updated_places_changeset = Enum.map(updated_places, &Ecto.Changeset.change/1)
    { status, updated_category } = category
                                    |> Ecto.Changeset.change
                                    |> Ecto.Changeset.put_assoc(:places, updated_places_changeset)
                                    |> Repo.update

    updated_category = Repo.get_by!(Category, id: updated_category.id) |> Repo.preload(:places)
    place_count = length updated_category.places
    assert status == :ok
    assert updated_category.places
    assert place_count == 1
  end

  test "remove a place from category" do
    category = create(:category)
    place = create(:place)
    additional_place = create(:place)

    category = category |> Repo.preload(:places)
    places = [place, additional_place]
    places_changeset = Enum.map(places, &Ecto.Changeset.change/1)
    { :ok, category } = category
                            |> Ecto.Changeset.change
                            |> Ecto.Changeset.put_assoc(:places, places_changeset)
                            |> Repo.update

    updated_places = [hd(places)]
    updated_places_changeset = Enum.map(updated_places, &Ecto.Changeset.change/1)
    { status, updated_category } = category
                                    |> Ecto.Changeset.change
                                    |> Ecto.Changeset.put_assoc(:places, updated_places_changeset)
                                    |> Repo.update
    place_count = length updated_category.places
    assert status == :ok
    assert updated_category.places
    assert place_count == 1
  end

end
