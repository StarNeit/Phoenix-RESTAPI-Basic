defmodule Playdays.Api.V1.Admin.TagController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.Tag
  alias Playdays.Api.V1.ErrorView
  alias Playdays.Queries.TagQuery

  plug :put_tag when action in [:show, :update]
  plug :create_tag when action in [:create]
  plug :update_tag when action in [:update]

  def index(conn, _params) do
    tags = TagQuery.find_all

    conn |> render("index.json", tags: tags)
  end

  def show(conn, _params) do
    render(conn, "show.json", tag: conn.assigns.tag)
  end

  def create(conn, _params) do
    tag = conn.assigns.new_tag
    conn |> render("show.json", tag: tag)
  end

  def update(conn, _params) do
    tag = conn.assigns.updated_tag
    conn |> render("show.json", tag: tag)
  end

  defp put_tag(conn, _params) do
    id = conn.params["id"]
    query = TagQuery.find_one(%{id: id})
    case query do
      nil ->
        conn
          |> put_status(:not_found)
          |> render(ErrorView, "404.json")
      tag ->
        conn |> assign(:tag, tag)
    end
  end

  defp create_tag(%{params: %{"tag" => tag_params}} = conn, _opts) do
    changeset = %Tag{} |> Tag.changeset(tag_params)
    # tag = conn.assigns.tag
    # changeset = tag |> Tag.changeset(tag_params)

    case changeset |> Repo.insert do
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
        |> halt
      {:ok, tag} ->
        conn |> assign(:new_tag, tag)
    end
  end

  defp update_tag(%{params: %{"tag" => tag_params}} = conn, _opts) do
    tag = conn.assigns.tag |> Repo.preload([:places])
    changeset = tag |> Tag.changeset(tag_params)

    case Repo.update(changeset) do
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
        |> halt
      {:ok, tag} ->
        conn |> assign(:updated_tag, tag)
    end
  end
end
