defmodule Playdays.Services.Admin.Admin.LoginAdmin do

  alias Playdays.Repo
  alias Playdays.Queries.AdminQuery

  # def call(email, password) do
  #   AdminQuery.find_one(%{email: email})
  #   |> authenticate_admin(password)
  # end
  #
  # defp authenticate_admin(nil, password) do
  #   {:error, "unknown_email"}
  # end
  #
  # defp authenticate_admin(admin, password) do
  #   if(
  #     valid_password?(admin, password),
  #     do: {:ok, admin},
  #     else: {:error, "invalid_password"}
  #   )
  # end
  #
  # defp valid_password?(%{hashed_password: h_password}, password) do
  #   h_password == Hashing.call(password)
  # end

  def call(email, password) do
    AdminQuery.find_many(%{email: String.downcase(email), hashed_password: password})
    |> parse_result
  end

  defp parse_result([]) do
    {:error, "email or password is incorrect"}
  end

  defp parse_result([admin]) do
    {:ok, admin}
  end
end
