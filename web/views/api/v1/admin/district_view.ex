defmodule Playdays.Api.V1.Admin.DistrictView do
  use Playdays.Web, :view

  alias Playdays.Api.V1.Admin.RegionView

  @json_attrs ~W(id name region_id hex_color_code)a

  def render("index.json", %{districts: districts}) do
    %{ data: render_many(districts, __MODULE__, "district_details.json")}
  end


  def render("show.json", %{district: district}) do
    %{ data: render_one(district, __MODULE__, "district_details.json") }
  end


  def render("district_details.json", %{district: district}) do
    district
      |> _render_details
  end

  def _render_details(district) do
    district
      |> Map.take(@json_attrs)
      |> Map.put(:region, render_one(district.region, RegionView, "region_details.json"))
  end
end
