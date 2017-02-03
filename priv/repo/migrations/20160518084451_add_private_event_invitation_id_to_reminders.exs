defmodule Playdays.Repo.Migrations.AddPrivateEventInvitationIdToReminders do
  use Ecto.Migration

  def change do
    alter table(:reminders) do
      add :private_event_invitation_id, references(:private_event_invitations)
    end
  end
end
