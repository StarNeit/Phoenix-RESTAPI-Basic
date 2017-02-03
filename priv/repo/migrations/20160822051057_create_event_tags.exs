defmodule Playdays.Repo.Migrations.CreateEventTags do
  use Ecto.Migration

  def change do
    create table(:event_tags) do
      add :title, :string

      timestamps
    end

  create unique_index(:event_tags, [:title])
  end
end
