defmodule Playdays.Api.V1.Admin.TagView do
  use Playdays.Web, :view

  @json_attrs ~W(id title)a

  def render("index.json", %{tags: tags}) do
    %{ data: render_many(tags, __MODULE__, "tag_details.json")}
  end


  def render("show.json", %{tag: tag}) do
    %{ data: render_one(tag, __MODULE__, "tag_details.json") }
  end


  def render("tag_details.json", %{tag: tag}) do
    tag
      |> _render_details
  end

  def _render_details(tag) do
    tag
      |> Map.take(@json_attrs)
  end
end
