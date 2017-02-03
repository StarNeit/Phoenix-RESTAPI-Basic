defmodule Playdays.Repo.Migrations.CreateSession do
  use Ecto.Migration

  def change do

    create table(:sessions) do
      add :consumer_id, references(:consumers), null: false
      add :time_slot_id, references(:time_slots), null: false
      add :status, :string

      timestamps
    end

    create unique_index(:sessions, [:consumer_id, :time_slot_id], name: :sessions_consumer_id_time_slot_id_index)
  end
end
