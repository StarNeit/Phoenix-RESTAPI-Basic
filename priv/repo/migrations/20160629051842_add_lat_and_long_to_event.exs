defmodule Playdays.Repo.Migrations.AddLatAndLongToEvent do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :lat, :string
      add :long, :string
    end
  end
end
