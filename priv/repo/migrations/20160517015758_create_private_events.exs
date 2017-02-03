defmodule Playdays.Repo.Migrations.CreatePrivateEvents do
  use Ecto.Migration

  def change do
    create table(:private_events) do
      add :name, :string
      add :date,     :date
      add :from,     :time
      add :to,       :time
      add :place_id, references(:places), null: false

      timestamps
    end

    create index(:private_events, [:name])
    create index(:private_events, [:place_id])
  end
end
