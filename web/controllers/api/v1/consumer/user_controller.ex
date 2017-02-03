defmodule Playdays.Api.V1.Consumer.UserController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.Api.V1.ErrorView
  alias Playdays.Consumer
  alias Playdays.Queries.ConsumerQuery

  # plug :scrub_params, "name" when action in [:index]
  plug :put_user when action in [:show]

  def index(conn, _params) do
    case conn.params do
      %{"name" => ""} ->
        render(conn, "index.json", users: [])

      %{"name" => name} ->
        users = ConsumerQuery.search(%{name: name})
                |> Repo.preload([:region, :district])
        conn |> render("index.json", users: users)

      %{"fb_user_id" => fb_user_id} ->
        users =
          ConsumerQuery.find_one(
            %{fb_user_id: fb_user_id},
            preload: [:region, :district]
          )
        users = if users, do: [users], else: []

        conn |> render("index.json", users: users)

      _ ->
        render(conn, "index.json", users: [])

    end
  end

  def show(conn, _params) do
    render(conn, "show.json", user: conn.assigns.user)
  end

  def put_user(conn, _params) do
    id = conn.params["id"]
    query = PlaceQuery.find_one(%{id: id})
    case query do
      nil ->
        conn
          |> put_status(:not_found)
          |> render(ErrorView, "404.json")
      user ->
        conn |> assign(:user, user)
    end
  end

end
