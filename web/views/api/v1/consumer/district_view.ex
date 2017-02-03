defmodule Playdays.Api.V1.Consumer.DistrictView do
  use Playdays.Web, :view

  @json_attrs ~W(id name region_id)a

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
  end
end
