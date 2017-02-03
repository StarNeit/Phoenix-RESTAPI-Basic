defmodule Playdays.Api.V1.Consumer.RegionView do
  use Playdays.Web, :view

  alias Playdays.Api.V1.Consumer.DistrictView
  @json_attrs ~W(id name)a

  def render("index.json", %{regions: regions}) do
    %{ data: render_many(regions, __MODULE__, "region_details.json")}
  end


  def render("show.json", %{region: region}) do
    %{ data: render_one(region, __MODULE__, "region_details.json") }
  end


  def render("region_details.json", %{region: region}) do
    region
      |> _render_details
  end

  def _render_details(region) do
    view = region
      |> Map.take(@json_attrs)

    if Ecto.assoc_loaded?(region.districts) do
      view = view
        |> Map.put(:districts, render_many(region.districts, DistrictView, "district_details.json"))
    end

    view
  end
end
