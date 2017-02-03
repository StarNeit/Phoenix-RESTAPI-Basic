defmodule Playdays.Services.Admin.Admin.LogoutAdmin do

  alias Playdays.Repo
  alias Playdays.Admin
  alias Playdays.SecureRandom

  def call(admin) do
    Admin.changeset(
      admin,
      %{authentication_token: SecureRandom.base64(16)}
    )
    |> Repo.update!
  end
end
