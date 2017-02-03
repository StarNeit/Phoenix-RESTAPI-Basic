defmodule Playdays.Api.V1.Admin.TrialClassController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.TrialClass
  alias Playdays.TimeSlot
  alias Playdays.Queries.TrialClassQuery
  alias Playdays.Services.Admin.TrialClass.UpdateTrialClass
  alias Playdays.Services.Admin.TrialClass.CreateTrialClass

  @trial_class_updatable struct(TrialClass)
    |> Map.keys
    |> Enum.map(&Atom.to_string/1)
  @time_slot_updatable struct(TimeSlot)
    |> Map.keys
    |> Enum.map(&Atom.to_string/1)

  # plug :scrub_params, "trial_class" when action in [:create, :update]
  plug :put_trial_class when action in [:show, :update, :delete]
  plug :create_trial_class when action in [:create]
  plug :update_trial_class when action in [:update]

  def index(conn, _params) do
    trial_classs = TrialClassQuery.find_all(preload: [:time_slots])
    render(conn, "index.json", trial_classs: trial_classs)
  end

  def create(conn, _params) do
    conn
    |> put_status(:created)
    |> put_resp_header("location", api_v1_admin_trial_class_path(conn, :create))
    |> render("show.json", trial_class: conn.assigns.new_trial_class)
  end

  def show(conn, _params) do
    render(conn, "show.json", trial_class: conn.assigns.trial_class)
  end

  def update(conn, _admin_params) do
    conn
    |> put_status(:ok)
    |> render("show.json", trial_class: conn.assigns.updated_trial_class)
  end

  def delete(conn, _params) do
    # TODO delete
  end

  defp put_trial_class(conn, _params) do
    query = TrialClassQuery.find_one(%{id: conn.params["id"]}, preload: [:time_slots])
    case query do
      nil ->
        conn
          |> put_status(:not_found)
          |> render(ErrorView, "404.json")
      trial_class ->
        conn |> assign(:trial_class, trial_class)
    end
  end

  defp update_trial_class(conn, _trial_class_params) do
    time_slots =
      conn.params["time_slots"] && conn.params["time_slots"]
      |> Enum.map(&(&1 |> Map.take(@time_slot_updatable) |> to_atom_keys))
    params =
      conn.params
      |> Map.take(@trial_class_updatable)
      |> to_atom_keys
      |> Map.put(:time_slots, time_slots)

    case UpdateTrialClass.call(conn.assigns.trial_class, params) do
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
        |> halt
      {:ok, trial_class} ->
        conn |> assign(:updated_trial_class, trial_class)
    end
  end

  defp create_trial_class(conn, _trial_class_params) do
    time_slots =
      conn.params["time_slots"] && conn.params["time_slots"]
      |> Enum.map(&(&1 |> Map.take(@time_slot_updatable) |> to_atom_keys))
    params =
      conn.params
      |> Map.take(@trial_class_updatable)
      |> to_atom_keys
      |> Map.put(:time_slots, time_slots)

    case CreateTrialClass.call(params) do
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
        |> halt
      {:ok, trial_class} ->
        conn |> assign(:new_trial_class, trial_class)
    end
  end

end
