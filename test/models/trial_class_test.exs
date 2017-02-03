defmodule Playdays.TrialClassTest do
  use Playdays.ModelCase

  alias Playdays.TrialClass
  alias Playdays.Repo

  @required_fields [:name, :website_url, :contact_number, :location_address, :description, :image]

  @valid_attrs %{
    name: "some content",
    website_url: "www.example.com",
    location_address: "some place maybe, i dont know",
    description: "some content",
    contact_number: "12346544",
    image: "no.image.com",
    time_slots: [%{date: 1460437072000, from: 1460516272000, to: 1460545072000}]
  }

  test "changeset with valid attributes" do
    changeset = TrialClass.changeset(%TrialClass{}, @valid_attrs)
    assert changeset.valid?
    {:ok, _} = Repo.insert changeset
  end

  test "event changeset with empty name should be invalid" do
    attrs = Map.merge @valid_attrs, %{name: ""}
    changeset = TrialClass.changeset(%TrialClass{}, attrs)
    refute changeset.valid?
    assert changeset.errors[:name] == {"can't be blank", []}
  end

  @required_fields
  |> Enum.each(
    &test "changeset with invalid attributes (without #{&1})" do
      attrs = Map.drop(@valid_attrs, [unquote(&1)])
      changeset = TrialClass.changeset(%TrialClass{}, attrs)
      refute changeset.valid?
    end
  )

end
