defmodule Playdays.Api.V1.Consumer.LoginControllerTest do
  use Playdays.ConnCase

  alias Playdays.Member
  @valid_attrs %{email: "@teset@example.com", password: "test123"}
  @invalid_attrs %{email: "non-test@example.com", password: "fgdfgdfgdfg"}

  setup %{conn: conn} do
    changeset =  Member.registration_changeset(%Member{}, @valid_attrs)
    Repo.insert changeset
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  # test "creates and renders resource when data is valid", %{conn: conn} do
  #   conn = post conn, api_v1_consumer_login_path(conn, :create), member: @valid_attrs
  #   assert token = json_response(conn, 201)["data"]["token"]
  #   assert Repo.get_by(Login, token: token)
  # end

  # test "does not create resource and renders errors when password is invalid", %{conn: conn} do
  #   conn = post conn, api_v1_consumer_login_path(conn, :create), member: Map.put(@valid_attrs, :password, "notright")
  #   assert json_response(conn, 401)["errors"] != %{}
  # end

  # test "does not create resource and renders errors when email is invalid", %{conn: conn} do
  #   conn = post conn, api_v1_consumer_login_path(conn, :create), member: Map.put(@valid_attrs, :email, "not@found.com")
  #   assert json_response(conn, 401)["errors"] != %{}
  # end
end
