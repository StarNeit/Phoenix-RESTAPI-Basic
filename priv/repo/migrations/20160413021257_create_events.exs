defmodule Playdays.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :website_url, :string
      add :location_address, :text
      add :description, :text
      add :price_range, :map
      add :contact_number, :string
      add :image, :string

      timestamps
    end
  end

end
