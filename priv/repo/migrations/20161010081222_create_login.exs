defmodule Playdays.Repo.Migrations.CreateLogin do
  use Ecto.Migration

  def change do
    create table(:logins) do
      add :token, :string
      add :member_id, references(:members, on_delete: :nothing)

      timestamps
    end
    create index(:logins, [:member_id])
    create index(:logins, [:token])
    
  end
end
