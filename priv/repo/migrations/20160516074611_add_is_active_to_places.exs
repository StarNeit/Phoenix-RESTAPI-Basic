defmodule Playdays.Repo.Migrations.AddIsActiveToPlaces do
  use Ecto.Migration

  def change do
    alter table(:places) do
      add :is_active, :boolean, default: true
    end
  end
end
