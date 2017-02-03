defmodule Playdays.Repo.Migrations.AddImageToTrialClasses do
  use Ecto.Migration

  def change do
    alter table(:trial_class) do
      add :image, :string
    end
  end
end
