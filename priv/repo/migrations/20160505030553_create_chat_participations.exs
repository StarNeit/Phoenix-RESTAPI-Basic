defmodule Playdays.Repo.Migrations.CreateChatParticipations do
  use Ecto.Migration

  def up do
    create table(:chat_participations) do
      add :chatroom_id, references(:chatrooms)
      add :consumer_id, references(:consumers)

      timestamps
    end

    create index(:chat_participations, [:chatroom_id])
    create index(:chat_participations, [:consumer_id])

    execute("CREATE UNIQUE INDEX index_c_p_on_cr_id_c_id_uni_idx ON chat_participations(chatroom_id, consumer_id) WHERE consumer_id IS NOT NULL")
  end

  def down do
    execute("DROP INDEX index_c_p_on_c_r_id_c_id_uni_idx")

    drop index(:chat_participations, [:consumer_id])
    drop index(:chat_participations, [:chatroom_id])

    drop table(:chat_participations)
  end

end
