defmodule Playdays.Services.Consumer.PrivateEvent.JoinPrivateEvent do

  alias Playdays.Repo
  alias Playdays.PrivateEvent
  alias Playdays.PrivateEventParticipation

  def call(%{private_event: private_event, new_consumer_id: new_consumer_id}) do
    new_participation = %PrivateEventParticipation{consumer_id: new_consumer_id}
    private_event
      |> PrivateEvent.add_private_event_participation(new_participation)
      |> Repo.update
  end
end
