defmodule Playdays.Repo.Migrations.RenameCompaniesToPlaces do
  use Ecto.Migration

  def change do
    rename table(:companies), to: table(:places)
  end
end
