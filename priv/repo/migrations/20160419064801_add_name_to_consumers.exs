defmodule Playdays.Repo.Migrations.AddNameToConsumers do
  use Ecto.Migration

  def change do
    alter table(:consumers) do
      add :name, :string
    end
  end
end
