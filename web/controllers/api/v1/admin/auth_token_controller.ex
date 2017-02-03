defmodule Playdays.Api.V1.Admin.AuthTokenController do
  use Playdays.Web, :controller

  alias Playdays.Services.Admin.Admin.LoginAdmin
  alias Playdays.Services.Admin.Admin.LogoutAdmin

  plug :authenticate when action in [:create]

  def create(conn, _) do
    conn
    |> put_status(:created)
    |> render("show.json", admin: conn.assigns.current_admin)
  end

  def destroy(conn, _) do
    LogoutAdmin.call(conn.assigns.current_admin)
    conn |> send_resp(:no_content, "OK")
  end

  def authenticate(conn, _options) do
    case LoginAdmin.call(conn.params["email"], conn.params["password"]) do
      {:error, reason} ->
        conn
        |> send_resp(401, reason)
        |> halt
      {:ok, admin} ->
        assign(conn, :current_admin, admin)
    end
  end

end
