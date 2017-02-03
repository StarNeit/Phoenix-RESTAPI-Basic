defmodule Playdays.Repo.Migrations.AddLatAndLongToPlace do
  use Ecto.Migration

  def change do
    alter table(:places) do
      add :lat, :string
      add :long, :string
    end
  end
end
