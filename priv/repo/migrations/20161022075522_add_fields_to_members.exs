defmodule Playdays.Repo.Migrations.AddFieldsToMembers do
  use Ecto.Migration

  def change do
  	alter table(:members) do
        add :like_places, {:array, :integer}
        add :like_events, {:array, :integer}
    end
  end
end
