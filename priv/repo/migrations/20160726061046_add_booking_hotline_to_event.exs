defmodule Playdays.Repo.Migrations.AddBookingHotlineToEvent do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :booking_hotline, :string
    end
  end
end
