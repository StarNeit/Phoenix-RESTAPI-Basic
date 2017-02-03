defmodule Playdays.TaggingTest do
  use Playdays.ModelCase, async: false

  alias Playdays.Tagging

  setup do
    place = create(:place)
    tag = create(:tag)

    {:ok, place: place, tag: tag}
  end

  test "changeset with valid attributes", %{ place: place, tag: tag } do
    valid_attrs = %{
      place_id: place.id,
      tag_id: tag.id,
    }
    changeset = Tagging.changeset(%Tagging{}, valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    invalid_attrs = %{}
    changeset = Tagging.changeset(%Tagging{}, invalid_attrs)
    refute changeset.valid?
  end

  test "insert Tagging with same tag_id should raise InvalidChangesetError", %{ place: place, tag: tag } do
    another_place = create(:place)
    %Tagging{tag_id: tag.id, place_id: place.id} |> Repo.insert!
    %Tagging{tag_id: tag.id, place_id: another_place.id} |> Repo.insert!

    assert_raise Ecto.InvalidChangesetError, fn ->
      %Tagging{}
        |> Tagging.changeset(%{
              tag_id: tag.id,
              place_id: another_place.id
            })
        |> Repo.insert!
    end
  end

  test "insert Tagging with same place_id should raise InvalidChangesetError", %{ place: place, tag: tag } do
    another_tag = create(:tag)
    %Tagging{tag_id: tag.id, place_id: place.id} |> Repo.insert!
    %Tagging{tag_id: another_tag.id, place_id: place.id} |> Repo.insert!

    assert_raise Ecto.InvalidChangesetError, fn ->
      %Tagging{}
        |> Tagging.changeset(%{
            tag_id: another_tag.id,
            place_id: place.id
           })
        |> Repo.insert!
    end
  end

  test "insert Tagging with empty tag_id should raise InvalidChangesetError", %{ place: place } do

    assert_raise Ecto.InvalidChangesetError, fn ->
      %Tagging{}
      |> Tagging.changeset(%{
            tag_id: "",
            place_id: place.id
          })
      |> Repo.insert!
    end
  end

  test "insert Tagging with empty place_id should raise InvalidChangesetError", %{ tag: tag } do
    assert_raise Ecto.InvalidChangesetError, fn ->
      %Tagging{}
      |> Tagging.changeset(%{
            tag_id: tag.id,
            place_id: ""
          })
      |> Repo.insert!
    end
  end

end
