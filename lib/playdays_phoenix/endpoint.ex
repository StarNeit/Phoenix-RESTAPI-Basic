defmodule Playdays.Endpoint do
  use Phoenix.Endpoint, otp_app: :playdays

  socket "/socket", Playdays.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :playdays, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug CORSPlug, [
    headers:  [
      "Authorization", "Content-Type", "Accept", "Origin",
      "User-Agent", "DNT","Cache-Control", "X-Mx-ReqToken",
      "Keep-Alive", "X-Requested-With", "If-Modified-Since",
      "X-CSRF-Token", "X-User-Id", "X-FBSession-Token",
      "x-auth-token", "x-user-id", "x-device-uuid", 
      "x-access-token"
    ]
  ]

  plug Plug.Session,
    store: :cookie,
    key: "_playdays_key",
    signing_salt: "+TZL7Wp4"

  plug Playdays.Router
end
