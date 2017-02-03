defmodule Playdays.Repo.Migrations.CreateChatMessages do
  use Ecto.Migration

  def change do
    create table(:chat_messages) do
      add :chat_participation_id, references(:chat_participations), null: false
      add :text_content, :text

      timestamps
    end

    create index(:chat_messages, [:chat_participation_id])
  end
end
