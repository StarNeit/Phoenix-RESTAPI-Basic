defmodule Playdays.Repo.Migrations.CreateMember do
  use Ecto.Migration

  def change do
    create table(:members) do
      add :fname, :string
      add :lname, :string
      add :email, :string
      add :password_hash, :string
      add :about_me, :string
      add :languages, {:array, :string}
      add :mobile_phone_number, :string
      add :children, {:array, :string}
      add :devices, {:array, :map}
      add :region_id, references(:regions)
      add :district_id, references(:districts)

      timestamps
    end
    create unique_index(:members, [:email])  

  end
end
