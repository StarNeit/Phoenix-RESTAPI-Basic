defmodule Playdays.Repo.Migrations.AddIsGroupChatToChatrooms do
  use Ecto.Migration

  def change do
    alter table(:chatrooms) do
      add :is_group_chat, :boolean, default: false
    end
  end
end
