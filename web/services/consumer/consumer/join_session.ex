defmodule Playdays.Services.Consumer.Consumer.JoinSession do

  alias Playdays.Repo
  alias Playdays.Session

  def call(time_slot, consumer) do
    # not id to ensure consumer and time_slot exists

    status = %{status: is_nil(time_slot.trial_class_id) && "joined" || "pending"}

    %Session{
      consumer_id: consumer.id,
      time_slot_id: time_slot.id,
    }
    |> Session.changeset(status)
    |> Repo.insert
  end
end
