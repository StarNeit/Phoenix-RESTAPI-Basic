defmodule Playdays.Test.Services.Admin.Admin.LoginAdminTest do
  use Playdays.ModelCase, async: true

  alias Playdays.Services.Admin.Admin.LoginAdmin
  alias Playdays.SecureRandom
  alias Playdays.Queries.AdminQuery

  test "admin login with correct email and password" do
    password = SecureRandom.alphanumeric(8)
    admin = create(:admin, hashed_password: password)
    admin = AdminQuery.find_one(%{email: admin.email})

    { status, admin2 } = LoginAdmin.call(admin.email, password)

    assert status == :ok
    assert admin == admin2
  end

  test "admin login with wrong email should return {:error, reason}" do
    password = SecureRandom.alphanumeric(8)
    _admin = create(:admin, email: "1@admin.com", hashed_password: password)

    { :error, "email or password is incorrect" }
      = LoginAdmin.call("#{SecureRandom.alphanumeric(8)}@admin.com", password)
  end

  test "admin login with wrong password should return {:error, reason}" do
    password = SecureRandom.alphanumeric(8)
    _admin = create(:admin, email: "1@admin.com", hashed_password: password)

    { :error, "email or password is incorrect" }
      = LoginAdmin.call("1@admin.com", "notthesamepassword")
  end
end
