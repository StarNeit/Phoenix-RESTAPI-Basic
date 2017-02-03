defmodule Playdays.Plugs.Api.TokenAuth do
  use Phoenix.Controller
  import Plug.Conn
  import Ecto.Query

  def init(options) do
    options
  end

  def call(conn, options) do
    auth_token = get_auth_token(conn)
    result = validate_token(auth_token, options[:model])

    case result do
      :missing_token ->
        conn
        |> put_status(:unauthorized)
        |> render(Playdays.ErrorView, "401.json", %{message: "Missing valid API token"})
        |> halt
      :invalid_token ->
        conn
        |> put_status(:unauthorized)
        |> render(Playdays.ErrorView, "401.json", %{message: "Invalid API token"})
        |> halt
      { :authenticated, resource } ->
        conn
        |> assign(:"current_#{options[:model]}", resource)
    end
  end

  defp validate_token(token, model) do
    token |> assign_user(model)
  end

  defp assign_user(nil, _model) do
    :missing_token
  end

  defp assign_user(token, model) do
    model_module = :"Elixir.Playdays.#{String.capitalize(Atom.to_string(model))}"

    user =
      model_module
      |> where([u], u.authentication_token == ^token)
      |> Playdays.Repo.one

    case user do
      nil -> :invalid_token
      _ -> { :authenticated, user }
    end
  end

  defp get_auth_token(conn) do
    List.first(get_req_header(conn, "x-auth-token"))
  end
end
