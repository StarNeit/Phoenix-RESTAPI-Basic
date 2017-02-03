defmodule Playdays.Api.V1.Admin.AuthTokenControllerTest do
  use Playdays.ConnCase, async: false
  import Playdays.Utils.MapUtils

  alias Playdays.SecureRandom
  alias Playdays.Queries.AdminQuery

  setup do
    conn =
      conn()
      |> put_req_header("accept", "application/json")

    password = SecureRandom.alphanumeric(8)
    admin = create(:admin, hashed_password: password)
    admin = AdminQuery.find_one(%{email: admin.email})
    {:ok, conn: conn, admin: admin, password: password}
  end

  test "admin login with email and password successfully", %{conn: conn, admin: admin, password: password} do
    data = %{email: admin.email, password: password}
    conn = post(conn, api_v1_admin_auth_token_path(conn, :create), data)

    expected_data = %{
      id: admin.id,
      email: admin.email,
      auth_token: admin.authentication_token
    }

    response_data = json_response(conn, 201)["data"] |> to_atom_keys

    assert conn.status == 201
    assert response_data == expected_data
  end

  test "admin cannot login with incorrect email", %{conn: conn, admin: admin, password: password} do
    data = %{email: "text" <> admin.email, password: password}

    conn |> post(api_v1_admin_auth_token_path(conn, :create), data)
         |> assert_status(401)
  end

  test "admin cannot login with incorrect password", %{conn: conn, admin: admin, password: password} do
    data = %{email: admin.email, password: "text" <> password}

    conn |> post(api_v1_admin_auth_token_path(conn, :create), data)
         |> assert_status(401)
  end

  test "admin can logout", %{conn: conn, admin: admin} do
    conn
    |> put_auth_token(admin.authentication_token)
    |> delete(api_v1_admin_auth_token_path(conn, :destroy))
    |> assert_status(204)
  end
end
