defmodule Playdays.Repo.Migrations.AddConsumerIdToPrivateEvents do
  use Ecto.Migration

  def change do
    alter table(:private_events) do
      add :consumer_id, references(:consumers), null: false
    end
  end
end
