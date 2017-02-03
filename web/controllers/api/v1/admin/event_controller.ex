defmodule Playdays.Api.V1.Admin.EventController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.Event
  alias Playdays.TimeSlot
  alias Playdays.Queries.EventQuery
  alias Playdays.Services.Admin.Event.UpdateEvent
  alias Playdays.Services.Admin.Event.CreateEvent

  @event_updatable struct(Event)
    |> Map.keys
    |> Enum.map(&Atom.to_string/1)
  @time_slot_updatable struct(TimeSlot)
    |> Map.keys
    |> Enum.map(&Atom.to_string/1)

  # plug :scrub_params, "event" when action in [:create, :update]
  plug :put_event when action in [:show, :update, :delete]
  plug :create_event when action in [:create]
  plug :update_event when action in [:update]

  def index(conn, _params) do
    events = EventQuery.find_all(preload: [:time_slots, :event_tags])
    render(conn, "index.json", events: events)
  end

  def create(conn, _params) do
    conn
    |> put_status(:created)
    |> put_resp_header("location", api_v1_admin_event_path(conn, :create))
    |> render("show.json", event: conn.assigns.new_event)
  end

  def show(conn, _params) do
    render(conn, "show.json", event: conn.assigns.event)
  end

  def update(conn, _admin_params) do
    conn
    |> put_status(:ok)
    |> render("show.json", event: conn.assigns.updated_event)
  end

  def delete(conn, _params) do
    # TODO delete
  end

  defp put_event(conn, _params) do
    query = EventQuery.find_one(%{id: conn.params["id"]}, preload: [:time_slots, :event_tags])
    case query do
      nil ->
        conn
          |> put_status(:not_found)
          |> render(ErrorView, "404.json")
      event ->
        conn |> assign(:event, event)
    end
  end

  defp update_event(conn, _event_params) do
    time_slots =
      conn.params["time_slots"] && conn.params["time_slots"]
      |> Enum.map(&(&1 |> Map.take(@time_slot_updatable) |> to_atom_keys))
    params =
      conn.params
      |> Map.take(@event_updatable)
      |> to_atom_keys
      |> Map.put(:time_slots, time_slots)
      |> Map.put(:selected_event_tags_id, conn.params["selected_event_tags_id"])

    case UpdateEvent.call(conn.assigns.event, params) do
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
        |> halt
      {:ok, event} ->
        conn |> assign(:updated_event, event)
    end
  end

  defp create_event(conn, _event_params) do
    time_slots =
      conn.params["time_slots"] && conn.params["time_slots"]
      |> Enum.map(&(&1 |> Map.take(@time_slot_updatable) |> to_atom_keys))
    params =
      conn.params
      |> Map.take(@event_updatable)
      |> to_atom_keys
      |> Map.put(:time_slots, time_slots)
      |> Map.put(:selected_event_tags_id, conn.params["selected_event_tags_id"])

    case CreateEvent.call(params) do
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
        |> halt
      {:ok, event} ->
        conn |> assign(:new_event, event)
    end
  end

end
