defmodule Playdays.Repo.Migrations.CreateReminders do
  use Ecto.Migration

  def change do

    create table(:reminders) do
      add :state, :string
      add :reminder_type, :string

      add :consumer_id, references(:consumers), null: false
      add :friend_request_id, references(:friend_requests), null: true
      add :session_id, references(:sessions), null: true

      timestamps
    end

  end
end
