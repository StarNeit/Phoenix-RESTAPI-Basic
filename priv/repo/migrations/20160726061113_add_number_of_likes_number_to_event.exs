defmodule Playdays.Repo.Migrations.AddNumberOfLikesNumberToEvent do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :number_of_likes, :integer, default: 0
    end
  end
end
