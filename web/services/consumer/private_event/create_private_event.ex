defmodule Playdays.Services.Consumer.PrivateEvent.CreatePrivateEvent do

  alias Playdays.Repo
  alias Playdays.PrivateEvent

  def call(%{name: name, date: date, from: from, place_id: place_id, consumer_id: consumer_id, invited_consumer_ids: invited_consumer_ids}) do
    invitations = invited_consumer_ids |> Enum.map(fn(id) -> %{consumer_id: id}end)
    %PrivateEvent{}
    |> PrivateEvent.changeset(%{
        name: name,
        date: date,
        from: from,
        place_id: place_id,
        consumer_id: consumer_id,
        private_event_invitations: invitations,
      })
    |> Repo.insert
  end

  def call(%{name: name, date: date, from: from, place_id: place_id, consumer_id: consumer_id}) do
    %PrivateEvent{}
    |> PrivateEvent.changeset(%{
        name: name,
        date: date,
        from: from,
        place_id: place_id,
        consumer_id: consumer_id,
      })
    |> Repo.insert
  end

end
