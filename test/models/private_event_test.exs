defmodule Playdays.PrivateEventTest do
  use Playdays.ModelCase

  alias Playdays.Consumer
  alias Playdays.PrivateEvent

  @required_fields [:name, :location_address, :price_range]

  @valid_attrs %{
    name: "some content",
    date: 1460437072000,
    from: 1460516272000,
    place_id: 1,
    consumer_id: 1
  }

  #setup do
  #  consumer = create(:consumer) |> Repo.preload(:friends)
  #  another_consumer = create(:consumer) |> Repo.preload(:friends)
  #  consumer |> Consumer.add_friend(another_consumer) |> Repo.update!
  #  another_consumer |> Consumer.add_friend(consumer) |> Repo.update!

   # {:ok, consumer: consumer, another_consumer: another_consumer}
  #end

  test "changeset with valid attributes" do
    changeset = PrivateEvent.changeset(%PrivateEvent{}, @valid_attrs)
    assert changeset.valid?
  end

  test "event changeset with empty name should be invalid" do
    attrs = Map.merge @valid_attrs, %{name: ""}
    changeset = PrivateEvent.changeset(%PrivateEvent{}, attrs)
    refute changeset.valid?
    assert changeset.errors[:name] == {"can't be blank", []}
  end

  #test "create private event", %{ consumer: consumer } do
  #  place = create(:place)
  #  changeset = %PrivateEvent{}
  #              |> PrivateEvent.changeset(%{
  #                    name: "test",
  #                    date: 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now),
  #                    from: 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now),
  #                    place_id: place.id,
  #                    consumer_id: consumer.id
  #                  })
  #  { state, private_event } = changeset |> Repo.insert
  #  assert state == :ok
  #  private_event = private_event |> Repo.preload([:place, :consumer])
  #  place = place |> Repo.preload([:private_events])
  #  place_private_events_count = length place.private_events
  #  consumer = consumer |> Repo.preload([:private_events])
  #  consumer_private_events_count = length consumer.private_events

  # assert private_event.id
  #  assert private_event.place.id == place.id
  #  assert private_event.consumer.id == consumer.id
  #  assert place_private_events_count == 1
  #  assert consumer_private_events_count == 1
  #end

  #test "create private event with invitations", %{consumer: consumer, another_consumer: another_consumer} do
  #  place = create(:place)
  #  changeset = %PrivateEvent{}
  #              |> PrivateEvent.changeset(%{
  #                    name: "test",
  #                    date: 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now),
  #                    from: 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now),
  #                    place_id: place.id,
  #                    consumer_id: consumer.id,
  #                    private_event_invitations: [
  #                      %{consumer_id: another_consumer.id}
  #                    ]
  #                  })
  #  { state, private_event } = changeset |> Repo.insert
  #  assert state == :ok
  #   private_event = private_event |> Repo.preload([:place, :consumer, :private_event_invitations])
  #   place = place |> Repo.preload([:private_events])
  #   place_private_events_count = length place.private_events
  #   private_event = private_event |> Repo.preload([:private_event_invitations])
  #   private_event_invitations_count = length private_event.private_event_invitations
  #   consumer = consumer |> Repo.preload([:private_events])
  #   consumer_private_events_count = length consumer.private_events
  #   another_consumer = another_consumer |> Repo.preload([:private_event_invitations])
  #   another_consumer_private_event_invitations_count = length another_consumer.private_event_invitations

  #   assert private_event.id
  #   assert private_event.place.id == place.id
  #   assert private_event.consumer.id == consumer.id
  #   assert place_private_events_count == 1
  #   assert private_event_invitations_count == 1
  #   assert consumer_private_events_count == 1
  #   assert another_consumer_private_event_invitations_count == 1
  # end

end
