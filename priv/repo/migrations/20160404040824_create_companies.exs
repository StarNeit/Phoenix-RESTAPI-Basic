defmodule Playdays.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string
      add :website_url, :string
      add :contact_number, :string
      add :location_address, :text
      add :description, :text

      timestamps
    end

    create index(:companies, [:name], unique: true)
  end
end
