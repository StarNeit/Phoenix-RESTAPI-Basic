defmodule Playdays.Api.V1.Consumer.DistrictController do
  use Playdays.Web, :controller
  # import Playdays.Utils.MapUtils

  alias Playdays.Api.V1.ErrorView
  alias Playdays.District
  alias Playdays.Queries.DistrictQuery

  # plug :put_district when action in [:show]

  def index(conn, _params) do
    districts = District |> DistrictQuery.sort_by(asc: :name) |> DistrictQuery.many

    conn |> render("index.json", districts: districts)
  end

  # def show(conn, _params) do
  #   render(conn, "show.json", district: conn.assigns.district)
  # end
  #
  # def put_district(conn, _params) do
  #   id = conn.params["id"]
  #   query = DistrictQuery.find_one(%{id: id})
  #   case query do
  #     nil ->
  #       conn
  #         |> put_status(:not_found)
  #         |> render(ErrorView, "404.json")
  #     district ->
  #       conn |> assign(:district, district)
  #   end
  # end

end
