defmodule Playdays.Api.V1.Consumer.FriendController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.Api.V1.ErrorView
  alias Playdays.Consumer
  alias Playdays.Queries.ConsumerQuery

  plug :put_friend when action in [:show]

  def index(conn, _params) do
    params = conn.params |> to_atom_keys
    consumer = ConsumerQuery.with_friends conn.assigns.current_consumer

    conn |> render("index.json", friends: consumer.friends)
  end

  def show(conn, _params) do
    render(conn, "show.json", friend: conn.assigns.friend)
  end

  def put_friend(conn, _params) do
    id = conn.params["id"]
    query = ConsumerQuery.find_one(%{id: id}) |> Repo.preload([:region, :district])
    case query do
      nil ->
        conn
          |> put_status(:not_found)
          |> render(ErrorView, "404.json")
      friend ->
        conn |> assign(:friend, friend)
    end
  end

end
