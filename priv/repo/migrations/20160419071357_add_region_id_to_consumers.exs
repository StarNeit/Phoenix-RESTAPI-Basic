defmodule Playdays.Repo.Migrations.AddRegionIdToConsumers do
  use Ecto.Migration

  def change do
    alter table(:consumers) do
      add :region_id, references(:regions)
    end
  end
end
