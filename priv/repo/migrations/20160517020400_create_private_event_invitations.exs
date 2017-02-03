defmodule Playdays.Repo.Migrations.CreatePrivateEventInvitations do
  use Ecto.Migration

  def change do
    create table(:private_event_invitations) do
      add :private_event_id, references(:private_events), null: false
      add :consumer_id, references(:consumers), null: false

      timestamps
    end

    create index(:private_event_invitations, [:private_event_id])
    create unique_index(:private_event_invitations, [:private_event_id, :consumer_id])
  end
end
