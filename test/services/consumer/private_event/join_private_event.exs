defmodule Playdays.Services.Consumer.PrivateEvent.JoinPrivateEventTest do
  use Playdays.ModelCase, async: false

  alias Playdays.Repo
  alias Playdays.Services.Consumer.PrivateEvent.CreatePrivateEvent
  alias Playdays.Services.Consumer.PrivateEvent.JoinPrivateEvent


  test "join chatroom" do
    consumer = create(:consumer)
    second_consumer = create(:consumer)

    private_event = create(:private_event, %{consumer: consumer})

    { state, updated_private_event } = JoinPrivateEvent.call(%{private_event: private_event, new_consumer_id: second_consumer.id})

    updated_private_event = updated_private_event |> Repo.preload(:private_event_participations)
    private_event_participations_count = length updated_private_event.private_event_participations

    assert private_event_participations_count == 1

    consumer = consumer |> Repo.preload(:private_events)
    second_consumer = second_consumer |> Repo.preload(:joined_private_event)
    consumer_private_events_count = length consumer.private_events
    second_consumer_private_events_count = length second_consumer.joined_private_event

    assert consumer_private_events_count == 1
    assert second_consumer_private_events_count == 1
  end
end
