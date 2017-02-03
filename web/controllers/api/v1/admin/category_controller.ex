defmodule Playdays.Api.V1.Admin.CategoryController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.Category
  alias Playdays.Api.V1.ErrorView
  alias Playdays.Queries.CategoryQuery

  plug :put_category when action in [:show, :update]
  plug :create_category when action in [:create]
  plug :update_category when action in [:update]

  def index(conn, _params) do
    categories = CategoryQuery.find_all

    conn |> render("index.json", categories: categories)
  end

  def show(conn, _params) do
    render(conn, "show.json", category: conn.assigns.category)
  end

  def create(conn, _params) do
    category = conn.assigns.new_category
    conn |> render("show.json", category: category)
  end

  def update(conn, _params) do
    category = conn.assigns.updated_category
    conn |> render("show.json", category: category)
  end

  defp put_category(conn, _opts) do
    id = conn.params["id"]
    query = CategoryQuery.find_one(%{id: id})
    case query do
      nil ->
        conn
          |> put_status(:not_found)
          |> render(ErrorView, "404.json")
      category ->
        conn |> assign(:category, category)
    end
  end

  defp create_category(%{params: %{"category" => category_params}} = conn, _opts) do
    changeset = %Category{} |> Category.changeset(category_params)

    case changeset |> Repo.insert do
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
        |> halt
      {:ok, category} ->
        conn |> assign(:new_category, category)
    end
  end

  defp update_category(%{params: %{"category" => category_params}} = conn, _opts) do
    category = conn.assigns.category |> Repo.preload([:places])
    changeset = category |> Category.changeset(category_params)

    case Repo.update(changeset) do
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
        |> halt
      {:ok, category} ->
        conn |> assign(:updated_category, category)
    end
  end
end
