defmodule Playdays.RegionTest do
  use Playdays.ModelCase, async: true

  alias Playdays.Region

  @valid_attrs %{name: "region_1", hex_color_code: "#1"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Region.changeset(%Region{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Region.changeset(%Region{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "insert region with same name should raise ConstraintError" do
    region = create(:region)

    assert_raise Ecto.ConstraintError, fn ->
      %Region{
        name: region.name
      } |> Repo.insert!
    end
  end

  test "insert region with empty name should raise InvalidChangesetError" do
    assert_raise Ecto.InvalidChangesetError, fn ->
      %Region{}
      |> Region.changeset(%{
            name: ""
          })
      |> Repo.insert!
    end
  end
end
