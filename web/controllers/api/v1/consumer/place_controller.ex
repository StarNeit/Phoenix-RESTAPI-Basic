defmodule Playdays.Api.V1.Consumer.PlaceController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.Api.V1.ErrorView
  alias Playdays.Place
  alias Playdays.Queries.PlaceQuery

  plug :put_place when action in [:show]

  def index(conn, _params) do
    places = Place |> PlaceQuery.is_active |> PlaceQuery.include([:categories, :tags, :districts]) |> PlaceQuery.sort_by(asc: :name) |> PlaceQuery.many

    conn |> render("index_with_details.json", places: places)
  end

  def show(conn, _params) do
    render(conn, "show.json", place: conn.assigns.place)
  end

  def put_place(conn, _params) do
    id = conn.params["id"]
    query = PlaceQuery.find_one(%{id: id, is_active: true})
    case query do
      nil ->
        conn
          |> put_status(:not_found)
          |> render(ErrorView, "404.json")
      place ->
        conn |> assign(:place, place)
    end
  end

end
