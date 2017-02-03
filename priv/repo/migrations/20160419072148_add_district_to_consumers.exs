defmodule Playdays.Repo.Migrations.AddDistrictToConsumers do
  use Ecto.Migration

  def change do
    alter table(:consumers) do
      add :district_id, references(:districts)
    end
  end
end
