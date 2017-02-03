defmodule Playdays.Api.V1.Consumer.PlaceView do
  use Playdays.Web, :view

  alias Playdays.Api.V1.Consumer.CategoryView
  alias Playdays.Api.V1.Consumer.TagView
  alias Playdays.Api.V1.Consumer.DistrictView

  @json_attrs ~W(id name website_url contact_number location_address description image lat long is_featured)a

  def render("index.json", %{places: places}) do
    %{ data: render_many(places, __MODULE__, "place_details.json")}
  end

  def render("index_with_details.json", %{places: places}) do
    %{ data: render_many(places, __MODULE__, "place_details_with_tag_and_category.json")}
  end

  def render("show.json", %{place: place}) do
    %{ data: render_one(place, __MODULE__, "place_details.json") }
  end

  def render("place_lite.json", %{place: place}) do
    place
      |> _render_lite
  end

  def render("place_details.json", %{place: place}) do
    place
      |> _render_details
  end

  def render("place_details_with_tag_and_category.json", %{place: place}) do
    place
      |> _render_tag_and_category_details
  end

  defp _render_lite(place) do
    place
      |> Map.take(@json_attrs)
  end

  defp _render_details(place) do
    place
      |> _render_lite
  end

  defp _render_tag_and_category_details(place) do
    place
      |> _render_lite
      |> Map.put(:categories, render_many(place.categories, CategoryView, "category_details.json"))
      |> Map.put(:tags, render_many(place.tags, TagView, "tag_details.json"))
      |> Map.put(:districts, render_many(place.districts, DistrictView, "district_details.json"))
  end

end
