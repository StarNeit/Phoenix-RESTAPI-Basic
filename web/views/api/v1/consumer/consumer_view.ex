defmodule Playdays.Api.V1.Consumer.ConsumerView do
  use Playdays.Web, :view

  alias Playdays.Api.V1.Consumer.ChildView
  alias Playdays.Api.V1.Consumer.RegionView
  alias Playdays.Api.V1.Consumer.DistrictView

  @json_attrs ~W(id name fb_user_id about_me inserted_at updated_at)a

  def render("index.json", %{consumers: consumers}) do
    %{ data: render_many(consumers, __MODULE__, "consumer_details.json")}
  end

  def render("show.json", %{consumer: consumer}) do
    %{ data: render_one(consumer, __MODULE__, "consumer_details.json") }
  end

  def render("consumer_details.json", %{consumer: consumer}) do
    consumer
      |> _render
  end

  def render("consumer_lite.json", %{consumer: consumer}) do
    consumer
      |> _render_lite
  end

  defp _render_lite(consumer) do
    consumer
      |> Map.take(@json_attrs)
  end

  defp _render(consumer) do
    consumer
      |> _render_lite
      |> Map.put(:children, render_many(consumer.children, ChildView, "child_details.json"))
      |> Map.put(:region, render_one(consumer.region, RegionView, "region_details.json"))
      |> Map.put(:district, render_one(consumer.district, DistrictView, "district_details.json"))
  end
end
