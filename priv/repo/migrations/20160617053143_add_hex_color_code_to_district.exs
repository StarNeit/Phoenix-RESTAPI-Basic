defmodule Playdays.Repo.Migrations.AddHexColorCodeToDistrict do
  use Ecto.Migration

  def change do
    alter table(:districts) do
      add :hex_color_code, :string
    end

    create unique_index(:districts, [:hex_color_code])
  end
end
