defmodule Playdays.Repo.Migrations.CreateEventTaggings do
  use Ecto.Migration

  def change do
    create table(:event_taggings) do
      add :event_id, :integer
      add :event_tag_id, :integer
      timestamps
    end

    create unique_index(:event_taggings, [:event_tag_id, :event_id])
    create unique_index(:event_taggings, [:event_id, :event_tag_id])
  end
end
