defmodule Playdays.Repo.Migrations.AddPrivateEventIdReminders do
  use Ecto.Migration

  def change do
    alter table(:reminders) do
      add :private_event_participation_id, references(:private_event_participations);
    end
  end
end
