defmodule Playdays.Api.V1.Consumer.MemberControllerTest do
  use Playdays.ConnCase

  alias Playdays.Member
  @valid_attrs %{about_me: "I am a developer", children: "1988/07/25", district_id: "1", email: "test@test.com", fname: "Super", languages: "English", lname: "Developer", mobile_phone_number: "123456789", region_id: "1"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  # test "lists all entries on index", %{conn: conn} do
  #   conn = get conn, api_v1_consumer_member_path(conn, :index)
  #   assert json_response(conn, 200)["data"] == []
  # end

  # test "shows chosen resource", %{conn: conn} do
  #   member = Repo.insert! %Member{}
  #   conn = get conn, api_v1_consumer_member_path(conn, :show, member)
  #   assert json_response(conn, 200)["data"] == %{"id" => member.id,
  #     "fname" => member.fname,
  #     "lname" => member.lname,
  #     "email" => member.email,
  #     "password_hash" => member.password_hash,
  #     "region_id" => member.region_id,
  #     "district_id" => member.district_id,
  #     "about_me" => member.about_me,
  #     "languages" => member.languages,
  #     "mobile_phone_number" => member.mobile_phone_number,
  #     "children" => member.children}
  # end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, api_v1_consumer_member_path(conn, :show, -1)
    end
  end

  # test "creates and renders resource when data is valid", %{conn: conn} do
  #   conn = post conn, api_v1_consumer_member_path(conn, :create), member: @valid_attrs
  #   assert json_response(conn, 201)["data"]["id"]
  #   assert Repo.get_by(Member, @valid_attrs)
  # end

  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, api_v1_consumer_member_path(conn, :create), member: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  # test "updates and renders chosen resource when data is valid", %{conn: conn} do
  #   member = Repo.insert! %Member{}
  #   conn = put conn, api_v1_consumer_member_path(conn, :update, member), member: @valid_attrs
  #   assert json_response(conn, 200)["data"]["id"]
  #   assert Repo.get_by(Member, @valid_attrs)
  # end

  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   member = Repo.insert! %Member{}
  #   conn = put conn, api_v1_consumer_member_path(conn, :update, member), member: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  # test "Users should have unique emails", %{conn: conn} do
  #   post conn, api_v1_consumer_registration_path(conn, :create), member: @valid_attrs
  #   conn = post conn, api_v1_consumer_registration_path(conn, :create), member: @valid_attrs
  #   errors = json_response(conn, 422)["errors"]
  #   assert errors != %{}
  #   assert Map.has_key?(errors, "email")
  #   assert Map.get(errors, "email") == ["has already been taken"]
  # end

  test "deletes chosen resource", %{conn: conn} do
    member = Repo.insert! %Member{}
    conn = delete conn, api_v1_consumer_member_path(conn, :delete, member)
    assert response(conn, 204)
    refute Repo.get(Member, member.id)
  end
end
