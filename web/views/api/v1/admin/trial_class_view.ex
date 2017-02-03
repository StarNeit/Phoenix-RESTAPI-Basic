defmodule Playdays.Api.V1.Admin.TrialClassView do
  use Playdays.Web, :view

  alias Playdays.Api.V1.Admin.TimeSlotView

  @lite_attrs [:id, :name, :description, :is_active]
  @attrs [:website_url, :location_address, :contact_number, :image]

  def render("index.json", %{trial_classs: trial_classs}) do
    %{data: render_many(trial_classs, __MODULE__, "trial_class_lite.json")}
  end

  def render("show.json", %{trial_class: trial_class}) do
    %{data: render_one(trial_class, __MODULE__, "trial_class.json")}
  end

  def render("trial_class_lite.json", %{trial_class: trial_class}) do
    _render_lite(trial_class)
  end

  def render("trial_class_lite_no_time_slot.json", %{trial_class: trial_class}) do
    _render_lite_no_time_slot(trial_class)
  end

  def render("trial_class.json", %{trial_class: trial_class}) do
    _render(trial_class)
  end

  defp _render_lite_no_time_slot(trial_class) do
    trial_class
    |> Map.take(@lite_attrs)
  end

  defp _render_lite(trial_class) do
    trial_class
    |> _render_lite_no_time_slot
    |> Map.put(
      :time_slots, render_many(trial_class.time_slots, TimeSlotView, "time_slot_lite.json")
    )
  end

  defp _render(trial_class) do
    trial_class
    |> _render_lite
    |> Map.merge(Map.take(trial_class, @attrs))
  end

end
