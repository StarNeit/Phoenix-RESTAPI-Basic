defmodule Playdays.Repo.Migrations.CreatePlaceDistricts do
  use Ecto.Migration

  def change do
    create table(:place_districts) do
      add :district_id, :integer
      add :place_id,    :integer

      timestamps
    end

    create unique_index(:place_districts, [:place_id, :district_id])
    create unique_index(:place_districts, [:district_id, :place_id])
  end
end
