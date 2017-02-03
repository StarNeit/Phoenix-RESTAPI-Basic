defmodule Playdays.Services.Consumer.PrivateEventInvitation.AcceptPrivateEventInvitation do

  alias Playdays.Repo
  alias Playdays.PrivateEventInvitation

  def call(%{private_event_invitation: private_event_invitation}) do
    private_event_invitation
    |> PrivateEventInvitation.changeset(%{
        state: "accepted"
      })
    |> Repo.update
  end

end
