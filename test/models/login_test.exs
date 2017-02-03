defmodule Playdays.LoginTest do
  use Playdays.ModelCase

  alias Playdays.Login

  @valid_attrs %{member_id: "12345"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Login.changeset(%Login{}, @valid_attrs)
    assert changeset.valid?
  end

  # test "changeset with invalid attributes" do
  #   changeset = Login.changeset(%Login{}, @invalid_attrs)
  #   refute changeset.valid?
  # end

  # test "create_changeset with valid attributes" do
  #   changeset = Login.create_changeset(%Login{}, @valid_attrs)
  #   assert changeset.changes.token
  #   assert changeset.valid?
  # end

  # test "create_changeset with invalid attributes" do
  #   changeset = Login.create_changeset(%Login{}, @invalid_attrs)
  #   refute changeset.valid?
  # end
end
