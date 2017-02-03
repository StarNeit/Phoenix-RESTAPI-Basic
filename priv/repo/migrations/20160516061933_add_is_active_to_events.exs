defmodule Playdays.Repo.Migrations.AddIsActiveToEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :is_active, :boolean, default: true
    end
  end
end
