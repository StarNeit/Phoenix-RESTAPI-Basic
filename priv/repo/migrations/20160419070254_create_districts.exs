defmodule Playdays.Repo.Migrations.CreateDistricts do
  use Ecto.Migration

  def change do
    create table(:districts) do
      add :name, :string
      add :region_id, references(:regions)
      timestamps
    end

    create index(:districts, [:name], unique: true)
  end
end
