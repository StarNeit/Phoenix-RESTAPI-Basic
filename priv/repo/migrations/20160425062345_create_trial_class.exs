defmodule Playdays.Repo.Migrations.CreateTrialClass do
  use Ecto.Migration

  def change do
    create table(:trial_class) do
      add :name, :string
      add :website_url, :string
      add :contact_number, :string
      add :location_address, :text
      add :description, :text

      timestamps
    end

    alter table(:time_slots) do
      add :trial_class_id, references(:trial_class), null: true
    end
  end
end
