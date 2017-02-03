defmodule Playdays.PrivateEventInvitationTest do
  use Playdays.ModelCase

  alias Playdays.PrivateEventInvitation

  @required_fields [:name, :location_address, :price_range]

  @valid_attrs %{
    private_event_id: 1,
    consumer_id: 1,
  }

  @invalid_attrs %{
    private_event_id: 1
  }

  test "changeset with valid attributes" do
    changeset = PrivateEventInvitation.changeset(%PrivateEventInvitation{}, @valid_attrs)
    assert changeset.valid?
  end

  test "event changeset with empty name should be invalid" do
    changeset = PrivateEventInvitation.changeset(%PrivateEventInvitation{}, @invalid_attrs)
    refute changeset.valid?
  end

  #test "create private event invitation" do
  #  consumer = create(:consumer)
  #  private_event = create(:private_event)
  #  changeset = %PrivateEventInvitation{}
  #              |> PrivateEventInvitation.changeset(%{
  #                    private_event_id: private_event.id,
  #                    consumer_id: consumer.id
  #                  })
  #
  #  { state, private_event_invitation } = changeset |> Repo.insert
  #  consumer = consumer |> Repo.preload([:private_event_invitations])
  #  private_event_invitations_count = length consumer.private_event_invitations
  #  assert state == :ok
  #  assert private_event_invitation.id
  #  assert private_event_invitations_count == 1
  #end
end
