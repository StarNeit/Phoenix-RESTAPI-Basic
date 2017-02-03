use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.

# Configure your database
config :playdays_backend_phoenix, PlaydaysBackendPhoenix.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "playdays_backend_phoenix_staging",
  hostname: "10.130.3.158",
  pool_size: 10
