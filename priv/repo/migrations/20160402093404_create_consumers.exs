defmodule Playdays.Repo.Migrations.CreateConsumers do
  use Ecto.Migration

  def change do
    create table(:consumers) do
      add :email, :string
      add :fb_user_id, :string
      add :devices, {:array, :map}

      timestamps
    end

    create index(:consumers, [:email], unique: true)
    create index(:consumers, [:fb_user_id], unique: true)
  end
end
