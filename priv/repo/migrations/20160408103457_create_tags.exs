defmodule Playdays.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :title, :string

      timestamps
    end

    create unique_index(:tags, [:title])
  end
end
