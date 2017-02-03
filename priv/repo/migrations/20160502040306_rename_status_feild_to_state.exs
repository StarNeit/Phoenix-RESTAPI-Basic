defmodule Playdays.Repo.Migrations.RenameStatusFeildToState do
  use Ecto.Migration

  def change do
    rename table(:friend_relationships), :status, to: :state
    rename table(:friend_requests), :status, to: :state
  end
end
