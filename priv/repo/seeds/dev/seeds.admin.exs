import Ecto.Query
alias Playdays.Repo
alias Playdays.Admin
alias Playdays.SecureRandom


[
  %{ path: "admins.default.json" }
]
  |> Enum.each(fn(%{path: path}) ->
      path
      |> Path.absname("./priv/repo/seeds/#{Mix.env}/admin")
      |> Path.expand
      |> File.read!
      |> Poison.decode!
      |> Enum.each(fn(admin) ->
        %Admin{}
          |> Admin.changeset(%{
                email: admin["email"],
                hashed_password: admin["password"],
                authentication_token: SecureRandom.base64(16),
              })
        |> Repo.insert!
      end)
    end)
