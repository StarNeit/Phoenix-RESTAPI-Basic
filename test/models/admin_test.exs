defmodule Playdays.AdminTest do
  use Playdays.ModelCase, async: true

  alias Playdays.Admin
  alias Playdays.Crypto.Hashing

  @valid_attrs %{email: "admin@example.com", hashed_password: "1234", name: "some string"}
  @invalid_attrs %{email: "invalid"}

  test "changeset with valid attributes" do
    changeset = Admin.changeset(%Admin{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Admin.changeset(%Admin{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "save password will be value hashed" do
    admin = %Admin{email: "admin@example.com", hashed_password: "PLAINTEXT"} |> Repo.insert!

    hashed_password = Repo.get_by!(Admin, id: admin.id).hashed_password

    assert hashed_password != "PLAINTEXT"
    assert hashed_password == Hashing.call("PLAINTEXT")
  end

  test "insert admin with same email should ConstraintError" do
    admin = create(:admin, email: "admin@example.com")

    assert_raise Ecto.ConstraintError, fn ->
      %Admin{
        email: admin.email,
        hashed_password: "PLAINPASSWORD",
      } |> Repo.insert!
    end
  end

  test "insert admin with empty email should raise InvalidChangesetError" do
    assert_raise Ecto.InvalidChangesetError, fn ->
      %Admin{}
      |> Admin.changeset(%{
        email: "",
        hashed_password: "PLAINPASSWORD",
      })
      |> Repo.insert!
    end
  end

end
