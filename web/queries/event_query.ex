defmodule Playdays.Queries.EventQuery do
  import Ecto.Query

  alias Playdays.Event
  alias Playdays.TimeSlot
  use Playdays.Query, model: Event

  def all_events() do
    time_slots =
      TimeSlot
      |> where([t], not(is_nil(t.event_id)))
      |> many(sort_by: [asc: :date, asc: :from])
    event_ids = Enum.map(time_slots, &Map.fetch!(&1, :event_id)) |> Enum.uniq
    events =
      Event
      |> where([e], e.id in ^event_ids)
      |> many

    {events, time_slots}
  end

  def all_time_slot() do
    time_slots =
      TimeSlot
      |> where([t], not(is_nil(t.event_id)))
      |> many(sort_by: [asc: :date, asc: :from])
    # event_ids = Enum.map(time_slots, &Map.fetch!(&1, :event_id)) |> Enum.uniq
    # events =
    #   Event
    #   |> where([e], e.id in ^event_ids)
    #   |> many
    #
    # {events, time_slots}
    time_slots
  end

  def is_active(query) do
    query
      |> where([p], p.is_active == true)
  end

end
