defmodule Playdays.Repo.Migrations.CreateFriendRelationships do
  use Ecto.Migration

  def change do
    create table(:friend_relationships) do
      add :consumer_0_id, :integer
      add :consumer_1_id, :integer
      add :status, :string
      timestamps
    end

    create unique_index(:friend_relationships, [:consumer_0_id, :consumer_1_id])
    create unique_index(:friend_relationships, [:consumer_1_id, :consumer_0_id])
  end
end
