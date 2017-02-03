defmodule Playdays.Repo.Migrations.RenameTrialClassToTrialClasses do
  use Ecto.Migration

  def change do
    rename table(:trial_class), to: table(:trial_classes)
  end
end
