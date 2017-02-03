defmodule Playdays.Api.V1.Admin.DistrictController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.Api.V1.ErrorView
  alias Playdays.District
  alias Playdays.Queries.DistrictQuery

  plug :put_district when action in [:show, :update, :delete]
  plug :create_district when action in [:create]
  plug :update_district when action in [:update]

  def index(conn, _params) do
    districts = DistrictQuery.find_all(preload: [:region])
    conn |> render("index.json", districts: districts)
  end

  def show(conn, _params) do
    render(conn, "show.json", district: conn.assigns.district)
  end

  def create(conn, _params) do
    district = conn.assigns.new_district
    conn |> render("show.json", district: district)
  end

  def update(conn, _params) do
    district = conn.assigns.updated_district
    conn |> render("show.json", district: district)
  end

  def put_district(conn, _params) do
    id = conn.params["id"]
    query = DistrictQuery.find_one(%{id: id}, preload: [:region])
    case query do
      nil ->
        conn
          |> put_status(:not_found)
          |> render(ErrorView, "404.json")
      district ->
        conn |> assign(:district, district)
    end
  end

  defp create_district(%{params: %{"district" => district_params}} = conn, _opts) do
    changeset = %District{} |> District.changeset(district_params)

    case Repo.insert(changeset) do
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
        |> halt
      {:ok, district} ->
        conn |> assign(:new_district, district)
    end
  end

  defp update_district(%{params: %{"district" => district_params}} = conn, _opts) do
    district = conn.assigns.district
    changeset = district |> District.changeset(district_params)

    case Repo.update(changeset) do
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
        |> halt
      {:ok, district} ->
        conn |> assign(:updated_district, district)
    end
  end
end
