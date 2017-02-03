defmodule Playdays.TagTest do
  use Playdays.ModelCase, async: true

  alias Playdays.Tag

  @valid_attrs %{title: "tag_1"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Tag.changeset(%Tag{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Tag.changeset(%Tag{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "insert tag with same title should raise ConstraintError" do
    tag = create(:tag)

    assert_raise Ecto.ConstraintError, fn ->
      %Tag{
        title: tag.title
      } |> Repo.insert!
    end
  end

  test "insert tag with empty title should raise InvalidChangesetError" do
    assert_raise Ecto.InvalidChangesetError, fn ->
      %Tag{}
      |> Tag.changeset(%{
            title: ""
          })
      |> Repo.insert!
    end
  end

  test "insert place to tag" do
    tag = create(:tag)
    place = create(:place)

    tag = tag |> Repo.preload(:places)
    places = tag.places ++ [place]
    places_changeset = Enum.map(places, &Ecto.Changeset.change/1)
    { status, tag } = tag
                            |> Ecto.Changeset.change
                            |> Ecto.Changeset.put_assoc(:places, places_changeset)
                            |> Repo.update

    place_count = length tag.places
    assert status == :ok
    assert tag.places
    assert place_count == 1
  end

  test "insert additional place to tag" do
    tag = create(:tag)
    place = create(:place)

    tag = tag |> Repo.preload(:places)
    places = tag.places ++ [place]
    places_changeset = Enum.map(places, &Ecto.Changeset.change/1)
    { :ok, tag } = tag
                            |> Ecto.Changeset.change
                            |> Ecto.Changeset.put_assoc(:places, places_changeset)
                            |> Repo.update

    additional_place = create(:place)
    updated_places = tag.places ++ [additional_place]
    updated_places_changeset = Enum.map(updated_places, &Ecto.Changeset.change/1)
    { status, updated_tag } = tag
                                    |> Ecto.Changeset.change
                                    |> Ecto.Changeset.put_assoc(:places, updated_places_changeset)
                                    |> Repo.update

    place_count = length updated_tag.places
    assert status == :ok
    assert updated_tag.places
    assert place_count == 2
  end

  test "cannot insert same place" do
    tag = create(:tag)
    place = create(:place)

    tag = tag |> Repo.preload(:places)
    places = tag.places ++ [place]
    places_changeset = Enum.map(places, &Ecto.Changeset.change/1)
    { :ok, tag } = tag
                            |> Ecto.Changeset.change
                            |> Ecto.Changeset.put_assoc(:places, places_changeset)
                            |> Repo.update

    updated_places = tag.places ++ [place]
    updated_places_changeset = Enum.map(updated_places, &Ecto.Changeset.change/1)
    { status, updated_tag } = tag
                                    |> Ecto.Changeset.change
                                    |> Ecto.Changeset.put_assoc(:places, updated_places_changeset)
                                    |> Repo.update

    updated_tag = Repo.get_by!(Tag, id: updated_tag.id) |> Repo.preload(:places)
    place_count = length updated_tag.places
    assert status == :ok
    assert updated_tag.places
    assert place_count == 1
  end

  test "remove a place from tag" do
    tag = create(:tag)
    place = create(:place)
    additional_place = create(:place)

    tag = tag |> Repo.preload(:places)
    places = [place, additional_place]
    places_changeset = Enum.map(places, &Ecto.Changeset.change/1)
    { :ok, tag } = tag
                            |> Ecto.Changeset.change
                            |> Ecto.Changeset.put_assoc(:places, places_changeset)
                            |> Repo.update

    updated_places = [hd(places)]
    updated_places_changeset = Enum.map(updated_places, &Ecto.Changeset.change/1)
    { status, updated_tag } = tag
                                    |> Ecto.Changeset.change
                                    |> Ecto.Changeset.put_assoc(:places, updated_places_changeset)
                                    |> Repo.update
    place_count = length updated_tag.places
    assert status == :ok
    assert updated_tag.places
    assert place_count == 1
  end

end
