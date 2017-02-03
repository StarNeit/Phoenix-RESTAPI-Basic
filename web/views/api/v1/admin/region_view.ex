defmodule Playdays.Api.V1.Admin.RegionView do
  use Playdays.Web, :view

  @json_attrs ~W(id name hex_color_code)a

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
    region
      |> Map.take(@json_attrs)
  end
end
