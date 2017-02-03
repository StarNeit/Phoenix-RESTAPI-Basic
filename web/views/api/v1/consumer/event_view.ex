defmodule Playdays.Api.V1.Consumer.EventView do
  use Playdays.Web, :view

  alias Playdays.Api.V1.Consumer.TimeSlotView
  alias Playdays.Api.V1.Consumer.EventTagView

  @json_attrs ~W(id name website_url contact_number location_address description image lat long joined_consumer_number booking_url booking_hotline number_of_likes booking_email is_featured)a

  def render("index.json", %{events: events}) do
    %{ data: render_many(events, __MODULE__, "event_details.json")}
  end

  def render("index.json", %{time_slots: time_slots}) do
    %{ data: render_many(time_slots, TimeSlotView, "time_slot_lite.json")}
  end

  # def render("index.json", %{events: events, time_slots: time_slots}) do
  #   %{
  #     data: %{
  #       events: render_many(events, __MODULE__, "event_lite.json"),
  #       time_slots: render_many(time_slots, TimeSlotView, "time_slot_lite.json")
  #     }
  #   }
  # end

  def render("show.json", %{event: event}) do
    %{ data: render_one(event, __MODULE__, "event_details.json") }
  end


  def render("event_details.json", %{event: event}) do
    event
    |> _render_details
  end

  def render("event_lite.json", %{event: event}) do
    event
    |> _render_lite
  end

  def _render_lite(event) do
    event
    |> Map.take(@json_attrs)
    |> _render_price_range(event.price_range)
  end

  def _render_details(event) do
    event
    |> _render_lite
    |> Map.put(
      :time_slots, render_many(event.time_slots, TimeSlotView, "time_slot_lite.json")
    )
    |> Map.put(
      :event_tags, render_many(event.event_tags, EventTagView, "event_tag_details.json" )
    )
  end

  defp _render_price_range(event, price_range) do
    Map.put(event, :price_range, Map.take(price_range, [:lo, :hi]))
  end

end
