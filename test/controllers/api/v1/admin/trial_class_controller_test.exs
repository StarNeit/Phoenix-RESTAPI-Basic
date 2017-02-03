defmodule Playdays.Api.V1.Admin.TrialClassControllerTest do
  use Playdays.ConnCase

  # alias Playdays.TrialClass
  alias Playdays.Queries.TrialClassQuery

  @valid_create_attrs %{
    name: "PaTesCo!",
    website_url: "www.PaTesCo.com",
    location_address: "some where exists, may be, i dont know",
    description: "some content",
    contact_number: "12346544",
    image: "no.image.com",
    is_active: true,
    time_slots: [
      %{
        date: 1460437072000,
        from: 1460516272000,
        to: 1460545072000,
      },
      %{
        date: 1460782672000,
        from: 1460516272000,
        to: 1460545072000,
      },
      %{
        date: 1461041872000,
        from: 1460516272000,
        to: 1460545072000,
      },
    ]
  }

  @valid_update_attrs %{
    name: Faker.Company.name,
    website_url: Faker.Internet.domain_name,
    location_address: Faker.Address.street_address,
    contact_number: "90139423",
    description: Faker.Lorem.paragraph,
    is_active: true
  }
  @number_of_trial_class 5

  setup do
    admin = create(:admin)
    trial_classs = create_list(@number_of_trial_class, :trial_class)

    conn =
      conn()
      |> put_req_header("accept", "application/json")
      |> put_req_header("x-auth-token", admin.authentication_token)
    {:ok, conn: conn, trial_classs: trial_classs}
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, api_v1_admin_trial_class_path(conn, :index)

    result = json_response(conn, 200)["data"]
    assert length(result) == @number_of_trial_class
  end

  test "shows chosen resource", %{conn: conn, trial_classs: trial_classs} do
    trial_class = Enum.at(trial_classs, 2)
    conn = get conn, api_v1_admin_trial_class_path(conn, :show, trial_class)

    expected_data = expected_render(trial_class)

    assert json_response(conn, 200)["data"] == expected_data
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, api_v1_admin_trial_class_path(conn, :create), @valid_create_attrs

    response = json_response(conn, 201)["data"]
    id = response["id"]

    assert id
    assert length(TrialClassQuery.find_one(%{id: id}, preload: [:time_slots]).time_slots) == 3
  end

  test "does not create trial_class and renders errors with out name", %{conn: conn} do
    attrs = @valid_create_attrs |> Map.drop([:name])

    conn = post conn, api_v1_admin_trial_class_path(conn, :create), attrs

    assert length(TrialClassQuery.find_all) == @number_of_trial_class
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "does not create trial_class and renders errors with out time_slots", %{conn: conn} do
    attrs = @valid_create_attrs |> Map.drop([:time_slots])

    conn = post conn, api_v1_admin_trial_class_path(conn, :create), attrs

    assert length(TrialClassQuery.find_all) == @number_of_trial_class
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "does not create trial_class and renders errors when time_slots is empty", %{conn: conn} do
    attrs = @valid_create_attrs |> Map.merge(%{time_slots: []})

    conn = post conn, api_v1_admin_trial_class_path(conn, :create), attrs

    assert length(TrialClassQuery.find_all) == @number_of_trial_class
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders trial_class when data is valid", %{conn: conn, trial_classs: [o_trial_class | _]} do
    time_slots = Enum.map(
      o_trial_class.time_slots,
      &%{
        id: &1.id,
        date: shift_days(&1.date, 2),
        from: 1556121600000,
        to: 1556157600000,
      }
    )
    valid_update_attrs = Map.put @valid_update_attrs, :time_slots, time_slots

    conn = put conn, api_v1_admin_trial_class_path(conn, :update, o_trial_class), valid_update_attrs

    trial_class = TrialClassQuery.find_one(%{id: o_trial_class.id}, preload: [:time_slots])

    assert json_response(conn, 200)["data"] == expected_render(trial_class)
    assert trial_class.name == @valid_update_attrs.name
    assert trial_class.website_url == @valid_update_attrs.website_url
    assert trial_class.location_address == @valid_update_attrs.location_address
    assert trial_class.contact_number == @valid_update_attrs.contact_number
    assert trial_class.description == @valid_update_attrs.description

    assert length(trial_class.time_slots) == length(o_trial_class.time_slots)
    Enum.zip(trial_class.time_slots, o_trial_class.time_slots)
    |> Enum.map(&(
      assert shift_days(elem(&1, 0).date, 0) == shift_days(elem(&1, 1).date, 2)
    ))
  end

  defp expected_render(trial_class) do
    %{
      "contact_number" => trial_class.contact_number,
      "description" => trial_class.description,
      "id" => trial_class.id,
      "location_address" => trial_class.location_address,
      "name" => trial_class.name,
      "website_url" => trial_class.website_url,
      "image" => trial_class.image,
      "is_active" => trial_class.is_active,
      "time_slots" => trial_class.time_slots |> Enum.map(&%{
        "id" => &1.id,
        "date" => ({&1.date |> Ecto.Date.to_erl, {0, 0, 0}} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
        "from" => ({{1970, 1, 2}, &1.from |> Ecto.Time.to_erl} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
        "to" => ({{1970, 1, 2}, &1.to |> Ecto.Time.to_erl} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000
      })
    }
  end

  defp shift_days(date, days) do
    (
      date
      |> Ecto.Date.to_erl
      |> Timex.DateTime.from_erl
      |> Timex.shift(days: days)
      |> Timex.DateTime.to_seconds
    ) * 1000
  end

end
