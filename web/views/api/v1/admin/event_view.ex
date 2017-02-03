defmodule Playdays.Api.V1.Admin.EventView do
  use Playdays.Web, :view

  alias Playdays.Api.V1.Admin.TimeSlotView
  alias Playdays.Api.V1.Admin.EventTagView

  @lite_attrs [:id, :name, :location_address]
  @attrs [:website_url, :description, :contact_number, :image, :is_active, :lat, :long, :booking_url, :booking_hotline, :booking_email, :is_featured]

  def render("index.json", %{events: events}) do
    # %{data: render_many(events, __MODULE__, "event_lite.json")}
    %{data: render_many(events, __MODULE__, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, __MODULE__, "event.json")}
  end

  def render("event_lite.json", %{event: event}) do
    _render_lite(event)
  end

  def render("event_lite_no_time_slot.json", %{event: event}) do
    _render_lite_no_time_slot(event)
  end

  def render("event.json", %{event: event}) do
    _render(event)
  end

  defp _render_lite(event) do
    event
    |> Map.take(@lite_attrs)
    |> Map.put(
      :time_slots, render_many(event.time_slots, TimeSlotView, "time_slot_lite.json")
    )
    |> Map.put(
      :event_tags, render_many(event.event_tags, EventTagView, "event_tag_details.json" )
    )
  end

  defp _render_lite_no_time_slot(event) do
    Map.take event, @lite_attrs
  end

  defp _render(event) do
    event
    |> _render_lite
    |> Map.merge(Map.take(event, @attrs))
    |> _render_price_range(event.price_range)
  end

  defp _render_price_range(event, price_range) do
    Map.put(event, :price_range, Map.take(price_range, [:lo, :hi]))
  end

end
