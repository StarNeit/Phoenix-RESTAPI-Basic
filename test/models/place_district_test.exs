defmodule Playdays.PlaceDistrictTest do
  use Playdays.ModelCase, async: false

  alias Playdays.PlaceDistrict

  setup do
    place = create(:place)
    district = create(:district)

    {:ok, place: place, district: district}
  end

  test "changeset with valid attributes", %{place: place, district: district} do
    valid_attrs = %{
      place_id: place.id,
      district_id: district.id,
    }
    changeset = PlaceDistrict.changeset(%PlaceDistrict{}, valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    invalid_attrs = %{}
    changeset = PlaceDistrict.changeset(%PlaceDistrict{}, invalid_attrs)
    refute changeset.valid?
  end

  test "insert PlaceDistrict with same district_id should raise InvalidChangesetError", %{place: place, district: district} do
    another_place = create(:place)
    %PlaceDistrict{district_id: district.id, place_id: place.id} |> Repo.insert!
    %PlaceDistrict{district_id: district.id, place_id: another_place.id} |> Repo.insert!

    assert_raise Ecto.InvalidChangesetError, fn ->
      %PlaceDistrict{}
        |> PlaceDistrict.changeset(%{
              district_id: district.id,
              place_id: another_place.id
            })
        |> Repo.insert!
    end
  end

  test "insert PlaceDistrict with same place_id should raise InvalidChangesetError", %{ place: place, district: district } do
    another_district = create(:district)
    %PlaceDistrict{district_id: district.id, place_id: place.id} |> Repo.insert!
    %PlaceDistrict{district_id: another_district.id, place_id: place.id} |> Repo.insert!

    assert_raise Ecto.InvalidChangesetError, fn ->
      %PlaceDistrict{}
        |> PlaceDistrict.changeset(%{
            district_id: another_district.id,
            place_id: place.id
           })
        |> Repo.insert!
    end
  end

  test "insert PlaceDistrict with empty district_id should raise InvalidChangesetError", %{ place: place } do
    assert_raise Ecto.InvalidChangesetError, fn ->
      %PlaceDistrict{}
      |> PlaceDistrict.changeset(%{
            district_id: "",
            place_id: place.id
          })
      |> Repo.insert!
    end
  end

  test "insert PlaceDistrict with empty place_id should raise InvalidChangesetError", %{district: district } do
    assert_raise Ecto.InvalidChangesetError, fn ->
      %PlaceDistrict{}
      |> PlaceDistrict.changeset(%{
            district_id: district.id,
            place_id: ""
          })
      |> Repo.insert!
    end
  end

end
