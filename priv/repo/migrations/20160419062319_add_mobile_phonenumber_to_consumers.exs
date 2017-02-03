defmodule Playdays.Repo.Migrations.AddMobilePhonenumberToConsumers do
  use Ecto.Migration

  def change do
    alter table(:consumers) do
      add :mobile_phone_number, :string
    end
  end
end
