defmodule Playdays.Repo.Migrations.AddLastReadChatMessageIdToChatParticipations do
  use Ecto.Migration

  def change do
    alter table(:chat_participations) do
      add :last_read_chat_message_id, references(:chat_messages)
    end
  end
end
