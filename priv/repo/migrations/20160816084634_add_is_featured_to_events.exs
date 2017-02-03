defmodule Playdays.Repo.Migrations.AddIsFeaturedToEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :is_featured, :boolean, default: false
    end
  end
end
