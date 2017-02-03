defmodule Playdays.Repo.Migrations.CreateAdmins do
  use Ecto.Migration

  def change do
    create table(:admins) do
      add :email, :string
      add :name, :string
      add :hashed_password, :string
      add :authentication_token, :string

      timestamps
    end

    create index(:admins, [:email], unique: true)
    create index(:admins, [:authentication_token], unique: true)
  end
end
