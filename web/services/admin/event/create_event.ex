defmodule Playdays.Services.Admin.Event.CreateEvent do

  alias Playdays.Repo
  alias Playdays.Event
  alias Playdays.TimeSlot
  alias Playdays.EventTag

  alias Playdays.Queries.EventQuery
  alias Playdays.Queries.EventTagQuery

  # def call(event_params) do
  #   event = %Event{}
  #   |> Event.changeset(event_params)
  #   |> Repo.insert
  #   with {:ok, event} <- event do
  #     {:ok, Repo.preload(event, [:time_slots])}
  #   end
  # end

  def call(event_params) do
    event_changeset = %Event{} |> Event.changeset(event_params)
      if event_params[:selected_event_tags_id] do
      event_tags_changeset = event_params[:selected_event_tags_id]
                        |> Enum.map(fn(id) ->
                            EventTagQuery.find_one(%{id: id})
                            |> Ecto.Changeset.change
                           end)
      IO.inspect event_tags_changeset
      event_changeset = event_changeset |> Ecto.Changeset.put_assoc(:event_tags, event_tags_changeset)
    end

    IO.inspect event_changeset

    event_changeset
      |> Repo.insert
    # with {:ok, event} <- event do
    #   {:ok, Repo.preload(event, [:time_slots])}
    # end
  end

  # def call(event_params, time_slots) do
  #   %Event{}
  #   |> Event.changeset(event_params)
  #   |> add_error_if_no_time_slots(time_slots)
  #   |> Repo.insert
  #   |> case do
  #     {:error, changeset} -> {:error, changeset}
  #     {:ok, event} ->
  #       create_time_slots(event, time_slots, [])
  #   end
  # end
  #
  # defp add_error_if_no_time_slots(event, time_slots) do
  #   if(
  #     time_slots == nil || time_slots == [],
  #     do: Ecto.Changeset.add_error(event, :time_slots, "can't be empty"),
  #     else: event
  #   )
  # end
  #
  # defp create_time_slots(%{id: event_id}, [], _), do:
  #   {:ok, EventQuery.find_one(%{id: event_id}, preload: [:time_slots])}
  #
  # defp create_time_slots(event, time_slots, created_time_slots) do
  #   time_slot = Map.put(hd(time_slots), :event_id, event.id)
  #   case TimeSlot.changeset(%TimeSlot{}, time_slot) |> Repo.insert do
  #     {:error, changeset} ->
  #       if created_time_slots !== [], do: delete created_time_slots
  #       delete event
  #       {:error, changeset}
  #     {:ok, time_slot} ->
  #       create_time_slots(event, tl(time_slots), created_time_slots ++ [time_slot])
  #   end
  # end
  #
  # defp delete([i]), do: Repo.delete i
  #
  # defp delete([h | t]) do
  #   Repo.delete h
  #   delete t
  # end
  #
  # defp delete(i), do: Repo.delete i

end
