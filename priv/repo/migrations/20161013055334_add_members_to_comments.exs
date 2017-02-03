defmodule Playdays.Repo.Migrations.AddMembersToComments do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :member_id, references(:members)

    end

  end
end
