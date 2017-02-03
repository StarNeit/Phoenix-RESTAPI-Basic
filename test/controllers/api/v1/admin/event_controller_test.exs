defmodule Playdays.Api.V1.Admin.EventControllerTest do
  use Playdays.ConnCase

  # alias Playdays.Event
  alias Playdays.Queries.EventQuery

  @valid_create_attrs %{
    name: "PaTesCo!11",
    website_url: "www.PaTesCo.com",
    location_address: "some where exists, may be, i dont know",
    price_range: %{hi: 122, lo: 100},
    description: "some content",
    contact_number: "12346544",
    image: "no.image.com",
    lat: "11.1223341",
    long: "11.1223341",
    is_active: true,
    is_featured: false,
    booking_url: "www.example.com/booking",
    booking_hotline: "12345678",
    booking_email: "monroe.schaefer@yahoo.com",
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
    price_range: %{hi: 64, lo: 24},
    lat: "22.3231990",
    long: "22.3231379",
    is_active: true,
    is_featured: false,
    booking_url: Faker.Internet.domain_name,
    booking_hotline: "28767890",
    booking_email: Faker.Internet.email,
  }
  @number_of_event 5

  setup do
    admin = create(:admin)
    events = create_list(@number_of_event, :event)

    conn =
      conn()
      |> put_req_header("accept", "application/json")
      |> put_req_header("x-auth-token", admin.authentication_token)
    {:ok, conn: conn, events: events}
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  # test "lists all entries on index", %{conn: conn} do
  #   conn = get conn, api_v1_admin_event_path(conn, :index)
  #
  #   result = json_response(conn, 200)["data"]
  #   assert length(result) == @number_of_event
  # end

  # test "shows chosen resource", %{conn: conn, events: events} do
  #   event = Enum.at(events, 2)
  #   conn = get conn, api_v1_admin_event_path(conn, :show, event)
  #
  #   expected_data = expected_render(event)
  #
  #   assert json_response(conn, 200)["data"] == expected_data
  # end

  test "creates and renders resource when data is valid", %{conn: conn} do
    event_tag = create(:event_tag)
    data =  Map.merge(@valid_create_attrs, %{selected_event_tags_id: [event_tag.id]})

    conn = post conn, api_v1_admin_event_path(conn, :create), data

    response = json_response(conn, 201)["data"]
    id = response["id"]
    found_event = EventQuery.find_one(%{id: id}, preload: [:time_slots, :event_tags])

    assert length(found_event.time_slots) == 3
    assert length(found_event.event_tags) == 1
  end

  # test "does not create event and renders errors with out name", %{conn: conn} do
  #   attrs = @valid_create_attrs |> Map.drop([:name])
  #
  #   conn = post conn, api_v1_admin_event_path(conn, :create), attrs
  #
  #   assert length(EventQuery.find_all) == @number_of_event
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  # test "does not create event and renders errors with out time_slots", %{conn: conn} do
  #   attrs = @valid_create_attrs |> Map.drop([:time_slots])
  #
  #   conn = post conn, api_v1_admin_event_path(conn, :create), attrs
  #
  #   assert length(EventQuery.find_all) == @number_of_event
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  # test "does not create event and renders errors when time_slots is empty", %{conn: conn} do
  #   attrs = @valid_create_attrs |> Map.merge(%{time_slots: []})
  #
  #   conn = post conn, api_v1_admin_event_path(conn, :create), attrs
  #
  #   assert length(EventQuery.find_all) == @number_of_event
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  # test "updates and renders event when data is valid", %{conn: conn, events: [o_event | _]} do
  #   time_slots = Enum.map(
  #     o_event.time_slots,
  #     &%{
  #       id: &1.id,
  #       date: shift_days(&1.date, 2),
  #       from: 1556121600000,
  #       to: 1556157600000,
  #     }
  #   )
  #   valid_update_attrs = Map.put @valid_update_attrs, :time_slots, time_slots
  #
  #   conn = put conn, api_v1_admin_event_path(conn, :update, o_event), valid_update_attrs
  #
  #   event = EventQuery.find_one(%{id: o_event.id}, preload: [:time_slots])
  #
  #   assert json_response(conn, 200)["data"] == expected_render(event)
  #   assert event.name == @valid_update_attrs.name
  #   assert event.website_url == @valid_update_attrs.website_url
  #   assert event.location_address == @valid_update_attrs.location_address
  #   assert event.contact_number == @valid_update_attrs.contact_number
  #   assert event.description == @valid_update_attrs.description
  #   assert event.booking_url == @valid_update_attrs.booking_url
  #   assert event.booking_hotline == @valid_update_attrs.booking_hotline
  #   assert event.booking_email == @valid_update_attrs.booking_email
  #
  #   assert length(event.time_slots) == length(o_event.time_slots)
  #   Enum.zip(event.time_slots, o_event.time_slots)
  #   |> Enum.map(&(
  #     assert shift_days(elem(&1, 0).date, 0) == shift_days(elem(&1, 1).date, 2)
  #   ))
  # end

  defp expected_render(event) do
    %{
      "contact_number" => event.contact_number,
      "description" => event.description,
      "id" => event.id,
      "location_address" => event.location_address,
      "name" => event.name,
      "website_url" => event.website_url,
      "price_range" => %{"hi" => event.price_range.hi, "lo" => event.price_range.lo},
      "image" => event.image,
      "lat" => event.lat,
      "long" => event.long,
      "is_active" => event.is_active,
      "is_featured" => event.is_featured,
      "booking_url" => event.booking_url,
      "booking_hotline" => event.booking_hotline,
      "booking_email" => event.booking_email,
      "time_slots" => event.time_slots |> Enum.map(&%{
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
