defmodule Playdays.Repo.Migrations.AddHexColorCodeToRegion do
  use Ecto.Migration

  def change do
    alter table(:regions) do
      add :hex_color_code, :string
    end

    create unique_index(:regions, [:hex_color_code])
  end
end
