defmodule Playdays.Repo.Migrations.AddFriendRequests do
  use Ecto.Migration

  def change do
    create table(:friend_requests) do
      add :requester_id, :integer
      add :requestee_id, :integer
      add :status, :string
      timestamps
    end
  end
end
