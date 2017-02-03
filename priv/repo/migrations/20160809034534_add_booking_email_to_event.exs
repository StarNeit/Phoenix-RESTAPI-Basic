defmodule Playdays.Repo.Migrations.AddBookingEmailToEvent do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :booking_email, :string
    end
  end
end
