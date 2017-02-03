defmodule Playdays.Api.V1.Consumer.ChildView do
  use Playdays.Web, :view

  @json_attrs ~W(id birthday)a

  def render("index.json", %{child: child}) do
    %{ data: render_many(child, __MODULE__, "child_details.json")}
  end


  def render("show.json", %{child: child}) do
    %{ data: render_one(child, __MODULE__, "child_details.json") }
  end


  def render("child_details.json", %{child: child}) do
    child
      |> _render_details
  end

  def _render_details(child) do
    child
      |> Map.take(@json_attrs)
  end
end
