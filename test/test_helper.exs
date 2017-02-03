Application.ensure_all_started(:ex_machina)
ExUnit.start


Mix.Task.run "ecto.create", ~w(-r Playdays.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Playdays.Repo --quiet)
Ecto.Adapters.SQL.Sandbox.mode(Playdays.Repo, :manual)
