defmodule Playdays.Repo.Migrations.CreateTaggings do
  use Ecto.Migration

  def change do
    create table(:taggings) do
      add :place_id, :integer
      add :tag_id,    :integer

      timestamps
    end

    create unique_index(:taggings, [:tag_id, :place_id])
    create unique_index(:taggings, [:place_id, :tag_id])
  end
end
