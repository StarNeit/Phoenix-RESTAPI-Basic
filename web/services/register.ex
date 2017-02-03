defmodule Playdays.Services.Register do

  alias Playdays.Repo
  alias Playdays.SecureRandom

  def call(register_params, model) do
    with(
      {:ok, changeset} <- gen_changeset(register_params, model),
      {:ok, user} <- Repo.insert(changeset),
      do: {:ok, Repo.get_by!(model, id: user.id)}
    )
  end

  defp valid_email?(email) do
    email != nil && email != ""
  end

  defp valid_password?(password) do
    password != nil && password != ""
  end

  defp gen_changeset(data, model) do
    cond do
      not valid_email?(data.email) -> {:error, "Invalid Email"}
      not valid_password?(data.password) -> {:error, "Invalid Password"}
      true ->
        data =
          Map.merge(data, %{
            hashed_password: data[:password],
            authentication_token: SecureRandom.base64(16),
            email: String.downcase(data[:email]),
          })
        {:ok, model.changeset(struct(model), data)}
    end
  end
end
