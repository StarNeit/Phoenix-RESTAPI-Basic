defmodule Playdays.Repo.Migrations.AddBookingUrlToEvent do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :booking_url, :string
    end
  end
end
