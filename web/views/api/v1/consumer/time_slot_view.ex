defmodule Playdays.Api.V1.Consumer.TimeSlotView do
  use Playdays.Web, :view

  alias Playdays.Api.V1.Consumer.EventView
  alias Playdays.Api.V1.Consumer.TrialClassView

  def render("index.json", %{time_slots: time_slots}) do
    %{data: render_many(time_slots, __MODULE__, "time_slot_lite.json")}
  end

  def render("show.json", %{time_slot: time_slot}) do
    %{data: render_one(time_slot, __MODULE__, "time_slot.json")}
  end

  def render("time_slot_lite.json", %{time_slot: time_slot}) do
    _render_lite(time_slot)
  end

  def render("time_slot.json", %{time_slot: time_slot}) do
    _render(time_slot)
  end

  defp _render_lite(time_slot) do
    %{
      id: time_slot.id,
      date: ({time_slot.date |> Ecto.Date.to_erl, {0, 0, 0}} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
      from: ({{1970, 1, 1}, time_slot.from |> Ecto.Time.to_erl} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
      to: ({{1970, 1, 1}, time_slot.to |> Ecto.Time.to_erl} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
      event_id: time_slot.event_id,
      trial_class_id: time_slot.trial_class_id,
    }
    |> Enum.filter(fn {_, v} -> v != nil end)
    |> Enum.into(%{})
  end

  defp _render(time_slot) do
    time_slot
    |> _render_lite
    |> _render_relation(time_slot)
  end

  defp _render_relation(time_slot, original_time_slot) do
    if !is_nil original_time_slot.event_id do
      time_slot = Map.put time_slot, :event, render_one(original_time_slot.event, EventView, "event_lite.json")
    end
    if !is_nil original_time_slot.trial_class_id do
      time_slot = Map.put time_slot, :trial_class, render_one(original_time_slot.trial_class, TrialClassView, "trial_class_lite_no_time_slot.json")
    end
    time_slot
  end

end
