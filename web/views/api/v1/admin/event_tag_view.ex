defmodule Playdays.Api.V1.Admin.EventTagView do
  use Playdays.Web, :view

  @json_attrs ~W(id title)a

  def render("index.json", %{event_tags: event_tags}) do
    %{ data: render_many(event_tags, __MODULE__, "event_tag_details.json")}
  end


  def render("show.json", %{event_tag: event_tag}) do
    %{ data: render_one(event_tag, __MODULE__, "event_tag_details.json") }
  end


  def render("event_tag_details.json", %{event_tag: event_tag}) do
    event_tag
      |> _render_details
  end

  def _render_details(event_tag) do
    event_tag
      |> Map.take(@json_attrs)
  end
end
