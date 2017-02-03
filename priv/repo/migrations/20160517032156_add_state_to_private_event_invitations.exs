defmodule Playdays.Repo.Migrations.AddStateToPrivateEventInvitations do
  use Ecto.Migration

  def change do
    alter table(:private_event_invitations) do
      add :state, :string
    end
  end
end
