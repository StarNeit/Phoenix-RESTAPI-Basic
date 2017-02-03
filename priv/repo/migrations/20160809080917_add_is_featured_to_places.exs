defmodule Playdays.Repo.Migrations.AddIsFeaturedToPlaces do
  use Ecto.Migration

  def change do
    alter table(:places) do
      add :is_featured, :boolean, default: false
    end
  end
end
