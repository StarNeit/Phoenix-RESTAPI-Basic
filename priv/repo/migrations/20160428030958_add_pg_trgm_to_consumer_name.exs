defmodule Playdays.Repo.Migrations.AddPgTrgmToConsumerName do
  use Ecto.Migration

  def up do
    execute "CREATE INDEX consumers_name_trgm_index ON consumers USING gin (name gin_trgm_ops);"
  end

  def down do
    execute "DROP INDEX consumers_name_trgm_index"
  end
end
