defmodule Playdays.Api.V1.Consumer.RegionController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.Api.V1.ErrorView
  alias Playdays.Region
  alias Playdays.Queries.RegionQuery

  def index(conn, _params) do
    regions = Region
    |> RegionQuery.include([:districts])
    |> RegionQuery.sort_by(asc: :name)
    |> RegionQuery.many

    conn |> render("index.json", regions: regions)
  end

end
