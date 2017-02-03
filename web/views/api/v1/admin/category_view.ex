defmodule Playdays.Api.V1.Admin.CategoryView do
  use Playdays.Web, :view

  @json_attrs ~W(id title hex_color_code image)a

  def render("index.json", %{categories: categories}) do
    %{ data: render_many(categories, __MODULE__, "category_details.json")}
  end


  def render("show.json", %{category: category}) do
    %{ data: render_one(category, __MODULE__, "category_details.json") }
  end


  def render("category_details.json", %{category: category}) do
    category
      |> _render_details
  end

  def _render_details(category) do
    category
      |> Map.take(@json_attrs)
  end
end
