defmodule Playdays.Services.Consumer.PrivateEvent.CreatePrivateEventTest do
  use Playdays.ModelCase, async: false

  alias Playdays.Repo
  alias Playdays.Consumer
  alias Playdays.PrivateEvent
  alias Playdays.Services.Consumer.PrivateEvent.CreatePrivateEvent

  setup do
    place = create(:place)
    consumer = create(:consumer) |> Repo.preload(:friends)
    another_consumer = create(:consumer) |> Repo.preload(:friends)
    consumer |> Consumer.add_friend(another_consumer) |> Repo.update!
    another_consumer |> Consumer.add_friend(consumer) |> Repo.update!

    {:ok, place: place, consumer: consumer, another_consumer: another_consumer}
  end

  test "create private event without invitations", %{place: place, consumer: consumer} do
    date = 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now)
    from = 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now)
    { state, private_event } = CreatePrivateEvent.call(%{name: "test", place_id: place.id, date: date, from: from, consumer_id: consumer.id })
    assert state == :ok
    consumer = consumer |> Repo.preload(:private_events)
    consumer_private_events_count = length consumer.private_events

    assert private_event.id
    assert consumer_private_events_count == 1
  end

  test "create private event with invitations", %{place: place, consumer: consumer, another_consumer: another_consumer} do
    date = 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now)
    from = 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now)
    { state, private_event } = CreatePrivateEvent.call(%{name: "test", place_id: place.id, date: date, from: from, consumer_id: consumer.id, invited_consumer_ids: [another_consumer.id] })
    assert state == :ok
    private_event = private_event |> Repo.preload(:private_event_invitations)
    private_event_invitations_count = length private_event.private_event_invitations
    consumer = consumer |> Repo.preload([:private_events])
    consumer_private_events_count = length consumer.private_events
    another_consumer = another_consumer |> Repo.preload([:private_event_invitations, :private_event_participations, :joined_private_events])
    another_consumer_private_event_invitations_count = length another_consumer.private_event_invitations
    another_consumer_private_event_participations_count = length another_consumer.private_event_participations
    another_consumer_joined_private_events_count = length another_consumer.joined_private_events


    assert private_event.id
    assert private_event_invitations_count == 1
    assert consumer_private_events_count == 1
    assert another_consumer_private_event_invitations_count == 1
    assert another_consumer_private_event_participations_count == 0
    assert another_consumer_joined_private_events_count == 0
  end
end
