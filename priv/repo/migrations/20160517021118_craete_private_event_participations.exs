defmodule Playdays.Repo.Migrations.CraetePrivateEventParticipations do
  use Ecto.Migration

  def change do
    create table(:private_event_participations) do
      add :private_event_id, references(:private_events), null: false
      add :consumer_id, references(:consumers), null: false

      timestamps
    end

    create unique_index(:private_event_participations, [:private_event_id, :consumer_id])
  end
end
