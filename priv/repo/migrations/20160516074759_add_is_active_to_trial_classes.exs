defmodule Playdays.Repo.Migrations.AddIsActiveToTrialClasses do
  use Ecto.Migration

  def change do
    alter table(:trial_classes) do
      add :is_active, :boolean, default: true
    end
  end
end
