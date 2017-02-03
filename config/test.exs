use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :playdays, Playdays.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :playdays, Playdays.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "playdays_dev",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :playdays, :ex_aws,
  s3: [
    region: "ap-southeast-1",
    access_key_id: "AKIAIFCX65MVRTQB2JFQ",
    secret_access_key: "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",
    bucket: "playdays-dev"
  ]

config :playdays, Playdays.PushNotificationClient,
  server_url: "http://localhost:9292",
  use_apn_production_gateway: false,
  gcm_api_key: "",
  apn_cert_path: "config/apple_push_notification_development.pem"
