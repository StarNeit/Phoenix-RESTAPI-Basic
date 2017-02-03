defmodule Playdays.Services.Admin.Event.UpdateEvent do

  alias Playdays.Repo
  alias Playdays.Event
  alias Playdays.EventTag
  alias Playdays.Queries.EventTagQuery

  # def call(event, event_params) do
  #   Event.changeset(event, event_params) |> Repo.update
  # end

  def call(event, event_params) do
    event_changeset = event |> Event.changeset(event_params)
    if event_params[:selected_event_tags_id] do
      event_tags_changeset = event_params[:selected_event_tags_id]
                        |> Enum.map(fn(id) ->
                            EventTagQuery.find_one(%{id: id})
                              |> Ecto.Changeset.change
                           end)

      event_changeset = event_changeset |> Ecto.Changeset.put_assoc(:event_tags, event_tags_changeset)
    end

    event_changeset
    |> Repo.update
  end

end
