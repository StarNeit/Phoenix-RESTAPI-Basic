defmodule Playdays.Api.V1.Admin.AdminControllerTest do
  use Playdays.ConnCase
  import Playdays.Utils.MapUtils

  @valid_registration_attrs %{
      email: "admin1@example.com",
      password: 'PlainText',
    }
  @valid_update_attrs %{
      email: "newnewnewnewnewnewenw@newnew.com",
      password: 'PlainText',
    }
  @number_of_admin 3

  setup do
    admins = create_list(@number_of_admin, :admin)

    conn =
      conn()
      |> put_req_header("accept", "application/json")
      |> put_req_header("x-auth-token", hd(admins).authentication_token)
    {:ok, conn: conn, admins: admins}
  end

  # test "list all admins successfully", %{conn: conn, admins: admins} do
  #   conn = get(conn, api_v1_admin_admin_path(conn, :index))
  #
  #   expected_data =
  #     Enum.map(admins, &Map.take(&1, [:id, :email, :name]))
  #
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #
  #   assert length(response_data) == @number_of_admin
  #   assert response_data == expected_data
  # end

  test "show a admin successfully", %{conn: conn, admins: admins} do
    admin = Enum.at(admins, 2)
    conn = get(conn, api_v1_admin_admin_path(conn, :show, admin))

    expected_data = Map.take(admin, [:id, :email, :name])

    response_data = json_response(conn, 200)["data"] |> to_atom_keys

    assert response_data == expected_data
  end

  test "admin register with email and password successfully", %{conn: conn} do
    data = @valid_registration_attrs
    conn = post(conn, api_v1_admin_admin_path(conn, :create), data)


    admin = conn.assigns.new_admin

    expected_data = %{
      id: admin.id,
      email: data.email,
      name: nil,
    }

    response_data = json_response(conn, 201)["data"] |> to_atom_keys

    assert response_data == expected_data
  end

  test "admin register with invalid email", %{conn: conn} do
    data = Map.merge(@valid_registration_attrs, %{email: "invalid"})

    conn |> post(api_v1_admin_admin_path(conn, :create), data)
         |> assert_status(422)
  end

  test "admin register with existed email", %{conn: conn} do
    admin = create(:admin, email: "exist@example.com")

    data = %{
      email: admin.email,
      password: "RandomText"
    }

    conn |> post(api_v1_admin_admin_path(conn, :create), data)
         |> assert_status(422)
  end

  test "admin update with email and password successfully", %{conn: conn, admins: [admin | _]} do
    data = @valid_update_attrs
    conn = put(conn, api_v1_admin_admin_path(conn, :update, admin), data)

    admin = conn.assigns.updated_admin

    expected_data = %{
      id: admin.id,
      email: data.email,
      name: admin.name,
    }

    response_data = json_response(conn, 200)["data"] |> to_atom_keys

    assert response_data == expected_data
  end

  test "admin update with invalid email", %{conn: conn, admins: [admin | _]} do
    data = Map.merge(@valid_registration_attrs, %{email: "invalid"})

    conn |> put(api_v1_admin_admin_path(conn, :update, admin), data)
         |> assert_status(422)
  end

  test "admin update with existed email", %{conn: conn, admins: [admin | _]} do
    existed_admin = create(:admin, email: "exist@example.com")

    data = %{
      email: existed_admin.email,
    }

    conn |> put(api_v1_admin_admin_path(conn, :update, admin), data)
         |> assert_status(422)
  end
end
