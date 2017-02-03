defmodule Playdays.Repo.Migrations.AddPrivateEventIdToChatrooms do
  use Ecto.Migration

  def change do
    alter table(:chatrooms) do
      add :private_event_id, references(:private_events), null: true
    end
  end
end
