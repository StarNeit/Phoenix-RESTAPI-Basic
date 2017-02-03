defmodule Playdays.Test.Services.Admin.Admin.LogoutAdminTest do
  use Playdays.ModelCase, async: true

  alias Playdays.Services.Admin.Admin.LogoutAdmin
  alias Playdays.SecureRandom
  alias Playdays.Queries.AdminQuery

  test "logout will thange the admin auth token" do
    auth_token = SecureRandom.base64(16)
    admin = create(:admin, authentication_token: auth_token)

    _admin = LogoutAdmin.call(admin)

    assert AdminQuery.find_one(%{id: admin.id}).authentication_token != auth_token
  end
end
