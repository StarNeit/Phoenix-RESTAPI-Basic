# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :playdays, Playdays.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "DT6qf3RUHIvEWBpSj7XRYjw1hV7YXuhLKterhN8oqiND/Ff/jrkhWhiPjYtZZiWU",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Playdays.PubSub,
           adapter: Phoenix.PubSub.PG2]

# config :playdays, Playdays.FBGraphAPIClient,
#   app_name: "PlayDays",
#   app_id: "1727532907504448",
#   app_secret: "be1f8f9dce8493eaec8905a54c7458ad",
#   app_token: "1727532907504448|2ezv_0x2u09Ic8ycUJTUmAnsw34",
#   host: "graph.facebook.com",
#   api_version: "2.5"
  # app_name: "PlayDays - Test1",
  # app_id: "1727533490837723",
  # app_secret: "45a888928ea82cc3c4ca466a29a1188a",
  # app_token: "1727533490837723|aNrnTZ18lrUP82ZD_7t63U8o6bU",
  # host: "graph.facebook.com",
  # api_version: "2.5"


# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :playdays, :ecto_repos, [Playdays.Repo]
