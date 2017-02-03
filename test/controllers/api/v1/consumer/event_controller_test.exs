defmodule Playdays.Api.V1.Consumer.EventControllerTest do
  use Playdays.ConnCase, async: false

  # import Mock
  import Playdays.Utils.MapUtils
  alias Playdays.Queries.EventQuery

  setup do
    conn = conn()
            |> put_req_header("accept", "application/json")

    # create(:event, name: "a")
    #
    #
    # event = create(:event, time_slots: [])
    # create(:time_slot, date: Ecto.Date.cast!("2016-02-01"), event_id: event.id)
    #
    # event = create(:event, time_slots: [])
    # create(:time_slot, date: Ecto.Date.cast!("2016-02-01"), event_id: event.id)

    {:ok, conn: conn, events: EventQuery.find_all}
  end


  test "list all events", %{conn: conn} do
    events = create_list(5, :event)

    conn = get conn, api_v1_consumer_event_path(conn, :index)

    events = conn.assigns.events

    expected_data = Enum.map(events, &expected_index_render/1)

    response_data = json_response(conn, 200)["data"]
    assert conn.status == 200
    assert response_data == expected_data
  end

  test "index events, should return with sorted time_slots", %{conn: conn} do
    event = create(:event, name: "2", time_slots: [])
    create(:time_slot, date: Ecto.Date.cast!("2016-01-31"), from: Ecto.Time.cast!("13:00:00Z"), event_id: event.id)

    event = create(:event, name: "3", time_slots: [])
    create(:time_slot, date: Ecto.Date.cast!("2016-02-01"), from: Ecto.Time.cast!("12:59:59Z"), event_id: event.id)

    event = create(:event, name: "1", time_slots: [])
    create(:time_slot, date: Ecto.Date.cast!("2016-01-31"), from: Ecto.Time.cast!("12:59:59Z"), event_id: event.id)

    conn = get conn, api_v1_consumer_event_path(conn, :index)

    time_slots = json_response(conn, 200)["data"]
    assert Enum.at(time_slots,0)["date"] <= Enum.at(time_slots,1)["date"]
    assert Enum.at(time_slots,1)["date"] <= Enum.at(time_slots,2)["date"]

    assert Enum.at(time_slots,0)["from"] <= Enum.at(time_slots,1)["from"]
  end

  # test "show a event", %{conn: conn} do
  #   create_list(2, :event)
  #   event = create(:event, name: "a", booking_hotline: "+85298765432", booking_url: "www.google.com", number_of_likes: 0, event_tags: [])
  #   create_list(3, :event)
  #   conn = get(conn, api_v1_consumer_event_path(conn, :show, event))
  #
  #   expected_data = expected_show_render event
  #
  #   response_data = json_response(conn, 200)["data"]
  #   assert conn.status == 200
  #   assert response_data == expected_data
  # end

  defp expected_index_render(event) do
    %{
      "id" => event.id,
      "location_address" => event.location_address,
      "name" => event.name,
      "image" => event.image,
      "lat" => event.lat,
      "long" => event.long,
      "website_url" => event.website_url,
      "contact_number" => event.contact_number,
      "is_featured" => event.is_featured,
      "description" => event.description,
      "joined_consumer_number" => event.joined_consumer_number,
      "number_of_likes" => event.number_of_likes,
      "price_range" => %{"hi" => event.price_range.hi, "lo" => event.price_range.lo},
      "booking_hotline" => event.booking_hotline,
      "booking_url" => event.booking_url,
      "booking_email" => event.booking_email,
      "event_tags" => event.event_tags,
      "time_slots" => event.time_slots |> Enum.map(&%{
        "id" => &1.id,
        "event_id" => &1.event_id,
        "date" => ({&1.date |> Ecto.Date.to_erl, {0, 0, 0}} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
        "from" => ({{1970, 1, 1}, &1.from |> Ecto.Time.to_erl} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
        "to" => ({{1970, 1, 1}, &1.to |> Ecto.Time.to_erl} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
      })
    }
  end

  defp expected_show_render(event) do
    event
    |> expected_index_render
    |> Map.merge(%{
      "time_slots" => event.time_slots |> Enum.map(&%{
        "id" => &1.id,
        "event_id" => &1.event_id,
        "date" => ({&1.date |> Ecto.Date.to_erl, {0, 0, 0}} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
        "from" => ({{1970, 1, 1}, &1.from |> Ecto.Time.to_erl} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
        "to" => ({{1970, 1, 1}, &1.to |> Ecto.Time.to_erl} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
      })
    })
  end

end
