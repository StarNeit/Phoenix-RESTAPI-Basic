defmodule Playdays.Api.V1.Consumer.TrialClassControllerTest do
  use Playdays.ConnCase, async: false

  # import Mock

  import Playdays.Utils.MapUtils
  alias Playdays.Queries.EventQuery

  setup do
    conn = conn()
            |> put_req_header("accept", "application/json")

    {:ok, conn: conn, trial_classes: EventQuery.find_all}
  end

  test "list all trial_classes", %{conn: conn} do
    trial_classes = create_list(5, :trial_class)

    conn = get conn, api_v1_consumer_trial_class_path(conn, :index)

    trial_classes = conn.assigns.trial_classes

    expected_data = Enum.map(trial_classes, &expected_index_render/1)

    response_data = json_response(conn, 200)["data"]
    assert conn.status == 200
    assert response_data == expected_data
  end

  test "index trial_classes, should return with sorted time_slots", %{conn: conn} do
    trial_class = create(:trial_class, name: "2", time_slots: [])
    create(:time_slot, date: Ecto.Date.cast!("2016-01-31"), from: Ecto.Time.cast!("13:00:00Z"), trial_class_id: trial_class.id)

    trial_class = create(:trial_class, name: "3", time_slots: [])
    create(:time_slot, date: Ecto.Date.cast!("2016-02-01"), from: Ecto.Time.cast!("12:59:59Z"), trial_class_id: trial_class.id)

    trial_class = create(:trial_class, name: "1", time_slots: [])
    create(:time_slot, date: Ecto.Date.cast!("2016-01-31"), from: Ecto.Time.cast!("12:59:59Z"), trial_class_id: trial_class.id)

    conn = get conn, api_v1_consumer_trial_class_path(conn, :index)

    time_slots = json_response(conn, 200)["data"]
    assert Enum.at(time_slots,0)["date"] <= Enum.at(time_slots,1)["date"]
    assert Enum.at(time_slots,1)["date"] <= Enum.at(time_slots,2)["date"]

    assert Enum.at(time_slots,0)["from"] <= Enum.at(time_slots,1)["from"]
  end

  test "show a trial_class", %{conn: conn} do
    create_list(2, :trial_class)
    trial_class = create(:trial_class, name: "a")
    create_list(3, :trial_class)
    conn = get(conn, api_v1_consumer_trial_class_path(conn, :show, trial_class))

    expected_data = expected_show_render trial_class

    response_data = json_response(conn, 200)["data"]
    assert conn.status == 200
    assert response_data == expected_data
  end

  defp expected_index_render(trial_class) do
    %{
      "id" => trial_class.id,
      "location_address" => trial_class.location_address,
      "name" => trial_class.name,
      "website_url" => trial_class.website_url,
      "contact_number" => trial_class.contact_number,
      "description" => trial_class.description,
      "image" => trial_class.image,
      "time_slots" => trial_class.time_slots |> Enum.map(&%{
        "id" => &1.id,
        "trial_class_id" => &1.trial_class_id,
        "date" => ({&1.date |> Ecto.Date.to_erl, {0, 0, 0}} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
        "from" => ({{1970, 1, 1}, &1.from |> Ecto.Time.to_erl} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
        "to" => ({{1970, 1, 1}, &1.to |> Ecto.Time.to_erl} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
      })
    }
  end

  defp expected_show_render(trial_class) do
    trial_class
    |> expected_index_render
    |> Map.merge(%{
      "time_slots" => trial_class.time_slots |> Enum.map(&%{
        "id" => &1.id,
        "trial_class_id" => &1.trial_class_id,
        "date" => ({&1.date |> Ecto.Date.to_erl, {0, 0, 0}} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
        "from" => ({{1970, 1, 1}, &1.from |> Ecto.Time.to_erl} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
        "to" => ({{1970, 1, 1}, &1.to |> Ecto.Time.to_erl} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
      })
    })
  end

end
