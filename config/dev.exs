use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :playdays, Playdays.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin"]]

# Watch static and templates for browser reloading.
config :playdays, Playdays.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :playdays, Playdays.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "admin",
  database: "playdays_dev",
  hostname: "localhost",
  pool_size: 10

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
  apn_cert_path: "config/apple_push_notification_development.pem"

import_config "dev.secret.exs"
