defmodule Playdays.Repo.Migrations.AddChildrenToConsumers do
  use Ecto.Migration

  def change do
    alter table(:consumers) do
      add :children, {:array, :map}
    end
  end
end
