defmodule Playdays.Repo.Migrations.AddDateIndexToTimeSlots do
  use Ecto.Migration

  def change do
    create index(:time_slots, [:date])
  end
end
