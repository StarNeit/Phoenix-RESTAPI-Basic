defmodule Playdays.Api.V1.Consumer.TrialClassController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.Api.V1.ErrorView
  alias Playdays.TrialClass
  alias Playdays.TimeSlot
  alias Playdays.Queries.TrialClassQuery
  alias Playdays.Queries.TimeSlotQuery

  plug :put_trial_class when action in [:show]

  def index(conn, _params) do
    trial_classes = TrialClassQuery.find_many(%{is_active: true}, preload: [:time_slots])


    conn |> render("index.json", trial_classes: trial_classes)
  end

  def show(conn, _params) do
    render(conn, "show.json", trial_class: conn.assigns.trial_class)
  end

  def put_trial_class(conn, _params) do
    id = conn.params["id"]
    query = TrialClassQuery.find_one(%{id: id, is_active: true}, preload: [:time_slots])
    case query do
      nil ->
        conn
          |> put_status(:not_found)
          |> render(ErrorView, "404.json")
      trial_class ->
        conn |> assign(:trial_class, trial_class)
    end
  end

end
