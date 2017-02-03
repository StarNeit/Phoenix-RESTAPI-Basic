defmodule Playdays.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :trial_class_id, references(:trial_classes)
      add :event_id, references(:events)
      add :place_id, references(:places)
      add :text_content, :text

      timestamps
    end

    create index(:comments, [:event_id])
    create index(:comments, [:trial_class_id])
    create index(:comments, [:place_id])
  end
end
