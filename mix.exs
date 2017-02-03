defmodule Playdays.Mixfile do
  use Mix.Project

  def project do
    [app: :playdays,
     version: "0.0.1",
     elixir: "1.2.3",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Playdays, []},
      applications: applications(Mix.env)
    ]
  end

  def applications(:dev) do
    applications(:all) ++ [:faker]
  end

  def applications(:staging) do
    applications(:all) ++ [:faker]
  end

  def applications(:test) do
    applications(:all) ++ [:mock, :faker, :ex_machina]
  end

  def applications(_all) do
    [
      :phoenix, :phoenix_html, :cowboy, :logger,
      :gettext, :phoenix_ecto, :postgrex, :mix,
      #:cors_plug, :timex, :httpoison, :sweet_xml, :erlcloud, :meck, :joken, :secure_random, :comeonin,
      #:joken, :secure_random, :comeonin
      :cors_plug, :timex, :httpoison, :sweet_xml, :erlcloud, :meck
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "1.1.4"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_ecto, "3.0.0-rc.0"},
     {:phoenix_html, "~> 2.4"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11.0"},
     {:cowboy, "~> 1.0"},
     {:secure_random, "~> 0.2"},
     {:cors_plug, "~> 0.1.3"},
     {:httpoison, "~> 0.8.2"},
     {:sweet_xml, "~> 0.2.1"},
     {:timex, "~> 2.1.4"},
     {:joken, "~> 1.1"},
     {:meck, "~> 0.8.4", override: true},
     {:mock, "~> 0.1.1", only: :test},
     {:erlcloud, git: "https://github.com/SWTPAIN/erlcloud"},
     {:ex_machina, "~> 0.6.1", only: :test},
     {:faker, "~> 0.6.0", only: [:dev, :test, :staging]},
     {:exrm, "~> 1.0.3"}]
  end
  #{:comeonin, "~> 2.0"},

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["seeds": ["run priv/repo/seeds.exs"],
     "ecto.setup": ["ecto.create", "ecto.migrate", "seeds"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "ps": ["phoenix.server"],
     "em": ["ecto.migrate"]]
  end

end
