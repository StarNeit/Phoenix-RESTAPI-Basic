defmodule Playdays.PrivateEventParticipationTest do
  use Playdays.ModelCase

  alias Playdays.PrivateEventInvitation
  alias Playdays.PrivateEventParticipation

  @required_fields [:name, :location_address, :price_range]

  @valid_attrs %{
    private_event_id: 1,
    consumer_id: 1,
  }

  @invalid_attrs %{
    private_event_id: 1
  }

  test "changeset with valid attributes" do
    changeset = PrivateEventParticipation.changeset(%PrivateEventParticipation{}, @valid_attrs)
    assert changeset.valid?
  end

  test "event changeset with empty name should be invalid" do
    changeset = PrivateEventParticipation.changeset(%PrivateEventParticipation{}, @invalid_attrs)
    refute changeset.valid?
  end

  #test "create private event Participation" do
  #  consumer = create(:consumer)
  #  private_event = create(:private_event)
  #  invitation = create(:private_event_invitation, %{ private_event: private_event, consumer: consumer})
  #  invitation = invitation |> PrivateEventInvitation.changeset(%{state: "accepted"}) |> Repo.update!

  # changeset = %PrivateEventParticipation{} |> PrivateEventParticipation.changeset(%{private_event_id: private_event.id, consumer_id: consumer.id})
  #  { state, participation } = changeset |> Repo.insert

  # consumer = consumer |> Repo.preload(:joined_private_events)
  #  consumer_joined_private_events_count = length consumer.joined_private_events
  #  assert invitation.state == "accepted"
  #  assert state == :ok
  #  assert participation.id
  #  assert consumer_joined_private_events_count == 1
  #end
end
