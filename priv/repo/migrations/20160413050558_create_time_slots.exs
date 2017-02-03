defmodule Playdays.Repo.Migrations.TimeSlots do
  use Ecto.Migration

  def change do
    create table(:time_slots) do
      add :date,     :date
      add :from,     :time
      add :to,       :time
      add :event_id, references(:events), null: true

      timestamps
    end

    create index(:time_slots, [:event_id])
  end
end
