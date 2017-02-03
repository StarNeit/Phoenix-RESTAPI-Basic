defmodule Playdays.Repo.Migrations.AddJoinedConsumerNumberToEvent do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :joined_consumer_number, :integer, default: 0
    end
  end
end
