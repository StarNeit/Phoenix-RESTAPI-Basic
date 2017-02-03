defmodule Playdays.MemberTest do
  use Playdays.ModelCase

  alias Playdays.Member

  @valid_attrs %{about_me: "I am a developer", children: "1988/07/25", district_id: "1", email: "test@test.com", fname: "Super", languages: "English", lname: "Developer", mobile_phone_number: "123456789", region_id: "1"}
  @invalid_attrs %{}

  # test "changeset with valid attributes" do
  #   changeset = Member.changeset(%Member{}, @valid_attrs)
  #   assert changeset.valid?
  # end

  test "changeset with invalid attributes" do
    changeset = Member.changeset(%Member{}, @invalid_attrs)
    refute changeset.valid?
  end

  # test "password_hash value gets set to a hash" do
  #   changeset = Member.changeset(%Member{}, @valid_attrs)
  #   #assert Comeonin.Bcrypt.checkpw(@valid_attrs.password, Ecto.Changeset.get_change(changeset, :password_hash))
  #   #assert (@valid_attrs.password, Ecto.Changeset.get_change(changeset, :password_hash))
  # end
end
