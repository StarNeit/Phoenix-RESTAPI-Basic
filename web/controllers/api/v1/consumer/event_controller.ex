defmodule Playdays.Api.V1.Consumer.EventController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.Api.V1.ErrorView
  alias Playdays.Event
  alias Playdays.TimeSlot
  alias Playdays.EventTag
  alias Playdays.Queries.EventQuery
  alias Playdays.Queries.TimeSlotQuery

  plug :put_event when action in [:show]

  def index(conn, _params) do
    events = EventQuery.find_many(%{is_active: true},preload: [:time_slots, :event_tags])
    conn |> render("index.json", events: events)
  end

  # def index(conn, _params) do
  #   # time_slots = TimeSlotQuery.find_all
  #
  #   {events, time_slots} = EventQuery.all_events
  #
  #   conn |> render("index.json", events: events, time_slots: time_slots)
  # end

  def show(conn, _params) do
    render(conn, "show.json", event: conn.assigns.event)
  end

  def put_event(conn, _params) do
    id = conn.params["id"]
    query = EventQuery.find_one(%{id: id, is_active: true}, preload: [:time_slots, :event_tags])
    case query do
      nil ->
        conn
          |> put_status(:not_found)
          |> render(ErrorView, "404.json")
      event ->
        conn |> assign(:event, event)
    end
  end

end
