defmodule Playdays.Repo.Migrations.AddAboutMeToConsumers do
  use Ecto.Migration

  def change do
    alter table(:consumers) do
      add :about_me, :text
    end
  end
end
