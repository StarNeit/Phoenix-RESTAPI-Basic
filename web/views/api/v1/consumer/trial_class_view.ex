defmodule Playdays.Api.V1.Consumer.TrialClassView do
  use Playdays.Web, :view

  alias Playdays.Api.V1.Consumer.TimeSlotView

  @json_attrs ~W(id name website_url contact_number location_address description image)a

  def render("index.json", %{trial_classes: trial_classes}) do
    %{ data: render_many(trial_classes, __MODULE__, "trial_class_details.json")}
  end

  def render("index.json", %{time_slots: time_slots}) do
    %{ data: render_many(time_slots, TimeSlotView, "time_slot_lite.json")}
  end

  def render("show.json", %{trial_class: trial_class}) do
    %{ data: render_one(trial_class, __MODULE__, "trial_class_details.json") }
  end

  def render("trial_class_lite_no_time_slot.json", %{trial_class: trial_class}) do
    _render_lite_no_time_slot(trial_class)
  end

  def render("trial_class_details.json", %{trial_class: trial_class}) do
    trial_class
    |> _render_details
  end

  defp _render_lite_no_time_slot(trial_class) do
    trial_class
    |> Map.take(@json_attrs)
  end

  def _render_details(trial_class) do
    trial_class
    |> _render_lite_no_time_slot
    |> Map.put(
      :time_slots, render_many(trial_class.time_slots, TimeSlotView, "time_slot_lite.json")
    )
  end

end
