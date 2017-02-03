defmodule Playdays.Repo.Migrations.AddImageToPlaces do
  use Ecto.Migration

  def change do
    alter table(:places) do
      add :image, :string
    end
  end
end
