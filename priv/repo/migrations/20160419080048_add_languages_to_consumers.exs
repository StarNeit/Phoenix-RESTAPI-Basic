defmodule Playdays.Repo.Migrations.AddLanguagesToConsumers do
  use Ecto.Migration

  def change do
    alter table(:consumers) do
      add :languages, {:array, :string}	
    end
  end
end
