defmodule Playdays.Api.V1.Admin.RegionController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.Api.V1.ErrorView
  alias Playdays.Region
  alias Playdays.Queries.RegionQuery

  plug :put_region when action in [:show, :update, :delete]
  plug :create_region when action in [:create]
  plug :update_region when action in [:update]

  def index(conn, _params) do
    regions = RegionQuery.find_all

    conn |> render("index.json", regions: regions)
  end

  def show(conn, _params) do
    render(conn, "show.json", region: conn.assigns.region)
  end

  def create(conn, _params) do
    region = conn.assigns.new_region
    conn |> render("show.json", region: region)
  end

  def update(conn, _params) do
    region = conn.assigns.updated_region
    conn |> render("show.json", region: region)
  end

  def put_region(conn, _params) do
    id = conn.params["id"]
    query = RegionQuery.find_one(%{id: id})
    case query do
      nil ->
        conn
          |> put_status(:not_found)
          |> render(ErrorView, "404.json")
      region ->
        conn |> assign(:region, region)
    end
  end

  defp create_region(%{params: %{"region" => region_params}} = conn, _opts) do
    changeset = %Region{} |> Region.changeset(region_params)

    case Repo.insert(changeset) do
      { :error, changeset } ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
        |> halt
      { :ok, region } ->
        conn |> assign(:new_region, region)
    end
  end

  defp update_region(%{params: %{"region" => region_params}} = conn, _opts) do
    region = conn.assigns.region
    changeset = region |> Region.changeset(region_params)

    case Repo.update(changeset) do
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
        |> halt
      {:ok, region} ->
        conn |> assign(:updated_region, region)
    end
  end
end
