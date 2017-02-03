defmodule Playdays.Repo.Migrations.CreateRegions do
  use Ecto.Migration

  def change do
    create table(:regions) do
      add :name, :string

      timestamps
    end

    create index(:regions, [:name], unique: true)
  end
end
