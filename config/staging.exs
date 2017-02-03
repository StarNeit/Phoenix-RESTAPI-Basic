use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
# config :playdays, Playdays.Endpoint,
#   http: [port: 4000],
#   debug_errors: true,
#   code_reloader: true,
#   check_origin: false,
#   watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin"]]

config :playdays, Playdays.Endpoint,
    http: [port: {:system, "PORT"}],
    url: [host: "139.59.230.97", port: 80],
    server: true,
    watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin"]],
    check_origin: false #["http://api-staging.playdays.co"]


# Watch static and templates for browser reloading.
# config :playdays, Playdays.Endpoint,
#   live_reload: [
#     patterns: [
#       ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
#       ~r{priv/gettext/.*(po)$},
#       ~r{web/views/.*(ex)$},
#       ~r{web/templates/.*(eex)$}
#     ]
#   ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20


import_config "staging.secret.exs"
