defmodule Playdays.Api.V1.Admin.EventTagController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.EventTag
  alias Playdays.Api.V1.ErrorView
  alias Playdays.Queries.EventTagQuery

  plug :put_event_tag when action in [:show, :update]
  plug :create_event_tag when action in [:create]
  plug :update_event_tag when action in [:update]

  def index(conn, _params) do
    event_tags = EventTagQuery.find_all

    conn |> render("index.json", event_tags: event_tags)
  end

  def show(conn, _params) do
    render(conn, "show.json", event_tag: conn.assigns.event_tag)
  end

  def create(conn, _params) do
    event_tag = conn.assigns.new_event_tag
    conn |> render("show.json", event_tag: event_tag)
  end

  def update(conn, _params) do
    event_tag = conn.assigns.updated_event_tag
    conn |> render("show.json", event_tag: event_tag)
  end

  defp put_event_tag(conn, _params) do
    id = conn.params["id"]
    query = EventTagQuery.find_one(%{id: id})
    case query do
      nil ->
        conn
          |> put_status(:not_found)
          |> render(ErrorView, "404.json")
      event_tag ->
        conn |> assign(:event_tag, event_tag)
    end
  end

  defp create_event_tag(%{params: %{"event_tag" => event_tag_params}} = conn, _opts) do
    changeset = %EventTag{} |> EventTag.changeset(event_tag_params)
    # tag = conn.assigns.tag
    # changeset = tag |> Tag.changeset(tag_params)

    case changeset |> Repo.insert do
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
        |> halt
      {:ok, event_tag} ->
        conn |> assign(:new_event_tag, event_tag)
    end
  end

  defp update_event_tag(%{params: %{"event_tag" => event_tag_params}} = conn, _opts) do
    event_tag = conn.assigns.event_tag |> Repo.preload([:events])
    changeset = event_tag |> EventTag.changeset(event_tag_params)

    case Repo.update(changeset) do
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
        |> halt
      {:ok, event_tag} ->
        conn |> assign(:updated_event_tag, event_tag)
    end
  end
end
