defmodule Playdays.Api.V1.Admin.PlaceController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.Api.V1.ErrorView
  alias Playdays.Place
  alias Playdays.Queries.PlaceQuery
  alias Playdays.Services.Admin.Place.CreatePlace
  alias Playdays.Services.Admin.Place.UpdatePlace

  plug :put_place when action in [:show, :update]
  plug :create_place when action in [:create]
  plug :update_place when action in [:update]


  def index(conn, _params) do
    places = Place
              |> PlaceQuery.include([:categories, :tags, districts: [:region]])
              |> PlaceQuery.sort_by(asc: :name)
              |> PlaceQuery.many

    conn |> render("index.json", places: places)
  end

  def show(conn, _params) do
    render(conn, "show.json", place: conn.assigns.place)
  end

  def create(conn, _admin_params) do
    place = conn.assigns.new_place
    conn
    |> put_status(:created)
    |> put_resp_header("location", api_v1_admin_place_path(conn, :create))
    |> render("show.json", place: place)
  end

  def update(conn, _params) do
    place = conn.assigns.updated_place
    conn
    |> put_status(:ok)
    |> put_resp_header("location", api_v1_admin_place_path(conn, :update,  place))
    |> render("show.json", place: place)
  end

  def put_place(conn, _params) do
    id = conn.params["id"]
    query =
      Place
      |> PlaceQuery.find_one(%{id: id}, preload: [:categories, :tags, districts: [:region]])

    case query do
      nil ->
        conn
          |> put_status(:not_found)
          |> render(ErrorView, "404.json")
      place ->
        conn |> assign(:place, place)
    end
  end

  defp create_place(conn, _params) do
    params = conn.params |> to_atom_keys
    case CreatePlace.call(params) do
      { :error, changeset } ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
        |> halt
      { :ok, place } ->
        conn |> assign(:new_place, Repo.preload(place, [:categories, :tags, districts: [:region]]))
    end
  end

  defp update_place(conn, _params) do

    params = conn.params |> to_atom_keys
    case UpdatePlace.call(conn.assigns.place, params) do
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
        |> halt
      {:ok, place} ->
        conn |> assign(:updated_place, Repo.preload(place, [:categories, :tags, districts: [:region]]))
    end
  end

end
