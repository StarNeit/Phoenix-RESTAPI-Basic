defmodule Playdays.Api.V1.Admin.ConsumerControllerTest do
  use Playdays.ConnCase
  import Playdays.Utils.MapUtils

  @valid_registration_attrs %{
      email: "consumer@example.com",
      password: 'PlainText',
    }
  @number_of_consumer 3

  setup do
    admin = create(:admin)
    consumers = create_list(@number_of_consumer, :consumer)

    conn =
      conn()
      |> put_req_header("accept", "application/json")
      |> put_req_header("x-auth-token", admin.authentication_token)
    {:ok, conn: conn, consumers: consumers}
  end

#  test "list all consumers successfully", %{conn: conn, consumers: consumers} do
#    conn = get(conn, api_v1_admin_consumer_path(conn, :index))

#    expected_data =
#      Enum.map(consumers, &Map.take(&1, [:id, :email, :name]))

#    response_data = json_response(conn, 200)["data"] |> to_atom_keys

#    assert length(response_data) == @number_of_consumer
#    assert response_data == expected_data
#  end

end
