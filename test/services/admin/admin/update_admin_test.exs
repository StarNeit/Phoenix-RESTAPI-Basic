defmodule Playdays.Test.Services.Admin.Admin.UpdateAdminTest do
  use Playdays.ModelCase

  alias Playdays.Services.Admin.Admin.UpdateAdmin

  setup do
    admins = create_list(2, :admin)
    {:ok, admins: admins}
  end

  test "update admin with valid attributes", %{admins: [admin1, _]} do
    {status, admin} = UpdateAdmin.call(admin1, %{email: "newnewnewnewnewnewnenew@newnew.com", password: "1234"})

    assert status == :ok
    assert admin.email == "newnewnewnewnewnewnenew@newnew.com"
    assert Map.get(admin, :password, nil) == nil
  end

  test "update admin with empty email should return {:error, reason}", %{admins: [admin1, _]} do
    {:error, _} = UpdateAdmin.call(admin1, %{email: ""})
  end

  test "update admin with exists email should return {:error, reason}", %{admins: [admin1, admin2]} do
    {:error, _} = UpdateAdmin.call(admin1, %{email: admin2.email})
  end

end
