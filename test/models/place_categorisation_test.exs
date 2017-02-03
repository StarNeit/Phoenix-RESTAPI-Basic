defmodule Playdays.PlaceCategorisationTest do
  use Playdays.ModelCase, async: false

  alias Playdays.PlaceCategorisation

  setup do
    place = create(:place)
    category = create(:category)

    {:ok, place: place, category: category}
  end

  test "changeset with valid attributes", %{ place: place, category: category } do
    valid_attrs = %{
      place_id: place.id,
      category_id: category.id,
    }
    changeset = PlaceCategorisation.changeset(%PlaceCategorisation{}, valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    invalid_attrs = %{}
    changeset = PlaceCategorisation.changeset(%PlaceCategorisation{}, invalid_attrs)
    refute changeset.valid?
  end

  test "insert PlaceCategorisation with same category_id should raise InvalidChangesetError", %{ place: place, category: category } do
    another_place = create(:place)
    %PlaceCategorisation{category_id: category.id, place_id: place.id} |> Repo.insert!
    %PlaceCategorisation{category_id: category.id, place_id: another_place.id} |> Repo.insert!

    assert_raise Ecto.InvalidChangesetError, fn ->
      %PlaceCategorisation{}
        |> PlaceCategorisation.changeset(%{
              category_id: category.id,
              place_id: another_place.id
            })
        |> Repo.insert!
    end
  end

  test "insert PlaceCategorisation with same place_id should raise InvalidChangesetError", %{ place: place, category: category } do
    another_category = create(:category)
    %PlaceCategorisation{category_id: category.id, place_id: place.id} |> Repo.insert!
    %PlaceCategorisation{category_id: another_category.id, place_id: place.id} |> Repo.insert!

    assert_raise Ecto.InvalidChangesetError, fn ->
      %PlaceCategorisation{}
        |> PlaceCategorisation.changeset(%{
            category_id: another_category.id,
            place_id: place.id
           })
        |> Repo.insert!
    end
  end

  test "insert PlaceCategorisation with empty category_id should raise InvalidChangesetError", %{ place: place } do
    assert_raise Ecto.InvalidChangesetError, fn ->
      %PlaceCategorisation{}
      |> PlaceCategorisation.changeset(%{
            category_id: "",
            place_id: place.id
          })
      |> Repo.insert!
    end
  end

  test "insert PlaceCategorisation with empty place_id should raise InvalidChangesetError", %{ category: category } do
    assert_raise Ecto.InvalidChangesetError, fn ->
      %PlaceCategorisation{}
      |> PlaceCategorisation.changeset(%{
            category_id: category.id,
            place_id: ""
          })
      |> Repo.insert!
    end
  end

end
