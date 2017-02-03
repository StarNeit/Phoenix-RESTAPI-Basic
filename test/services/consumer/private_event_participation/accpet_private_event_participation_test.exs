defmodule Playdays.Services.Consumer.PrivateEvent.AcceptPrivateEventInvitationTest do
  use Playdays.ModelCase, async: false

  alias Playdays.Repo
  alias Playdays.Consumer
  alias Playdays.PrivateEvent
  alias Playdays.Services.Consumer.PrivateEventInvitation.AcceptPrivateEventInvitation

  setup do
    place = create(:place)
    consumer = create(:consumer) |> Repo.preload(:friends)
    another_consumer = create(:consumer) |> Repo.preload(:friends)
    consumer |> Consumer.add_friend(another_consumer) |> Repo.update!
    another_consumer |> Consumer.add_friend(consumer) |> Repo.update!
    p = %PrivateEvent{}
    |> PrivateEvent.changeset(%{
        name: "test",
        date: 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now),
        from: 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now),
        place_id: place.id,
        consumer_id: another_consumer.id,
        private_event_invitations: [
          %{
            consumer_id: another_consumer.id
          }
        ]
      })
    |> Repo.insert!
    p = p |> Repo.preload([:private_event_invitations])
    private_event_invitation = hd p.private_event_invitations
    {:ok, private_event_invitation: private_event_invitation, consumer: consumer, another_consumer: another_consumer}
  end

  test "accept private event invitation", %{private_event_invitation: private_event_invitation, another_consumer: another_consumer} do
    { state, invitation } = AcceptPrivateEventInvitation.call(%{private_event_invitation: private_event_invitation})
    assert state == :ok
    assert invitation.state == "accepted"
  end
end
