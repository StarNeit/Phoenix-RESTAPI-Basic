defmodule Playdays.Repo.Migrations.AddHexColorCodeToCategory do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :hex_color_code, :string
    end

    create unique_index(:categories, [:hex_color_code])
  end
end
