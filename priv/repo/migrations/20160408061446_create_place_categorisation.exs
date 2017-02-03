defmodule Playdays.Repo.Migrations.CreatePlaceCategorisations do
  use Ecto.Migration

  def change do
    create table(:place_categorisations) do
      add :category_id, :integer
      add :place_id,    :integer

      timestamps
    end

    create unique_index(:place_categorisations, [:place_id, :category_id])
    create unique_index(:place_categorisations, [:category_id, :place_id])
  end
end
