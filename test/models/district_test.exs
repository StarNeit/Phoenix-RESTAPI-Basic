defmodule Playdays.DistrictTest do
  use Playdays.ModelCase, async: true

  alias Playdays.District

  @valid_attrs %{name: "district_1", region_id: "1", hex_color_code: "#1"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = District.changeset(%District{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = District.changeset(%District{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "insert district with same name should raise ConstraintError" do
    region = create(:region)
    district = create(:district)

    assert_raise Ecto.ConstraintError, fn ->
      %District{
        name: district.name,
        region: region
      }
      |> Repo.insert!
    end
  end

  test "insert district with empty name should raise InvalidChangesetError" do
    region = create(:region)
    assert_raise Ecto.InvalidChangesetError, fn ->
      %District{}
      |> District.changeset(%{
            name: "",
            region_id: region.id,
          })
      |> Repo.insert!
    end
  end
end
