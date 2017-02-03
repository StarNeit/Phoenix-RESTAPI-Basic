defmodule Playdays.Repo.Migrations.AddImageToCategories do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :image, :string
    end
  end
end
