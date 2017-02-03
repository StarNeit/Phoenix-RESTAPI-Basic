defmodule Playdays.Api.V1.Admin.AdminController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.Services.Admin.Admin.RegisterAdmin
  alias Playdays.Services.Admin.Admin.UpdateAdmin
  alias Playdays.Queries.AdminQuery
  alias Playdays.ErrorView

  @updatable ~w(name password email)

  plug :scrub_params, "email" when action in [:create]
  plug :scrub_params, "password" when action in [:create]
  plug :register_admin when action in [:create]
  plug :put_admin when action in [:show, :update, :delete]
  plug :update_admin when action in [:update]
  plug :validate_not_delete_self when action in [:delete]


  def index(conn, _params) do
    admins = AdminQuery.find_all
    conn |> render("index.json", admins: admins)
  end

  def show(conn, _params) do
    render(conn, "show.json", admin: conn.assigns.admin)
  end

  def delete(conn, _params) do
    Repo.delete!(conn.assigns.admin)
    send_resp(conn, :no_content, "")
  end

  def create(conn, _admin_params) do
    conn
    |> put_status(:created)
    |> put_resp_header("location", api_v1_admin_admin_path(conn, :create))
    |> render("show.json", admin: conn.assigns.new_admin)
  end

  def update(conn, _admin_params) do
    conn
    |> put_status(:ok)
    |> put_resp_header("location", api_v1_admin_admin_path(conn, :create))
    |> render("show.json", admin: conn.assigns.updated_admin)
  end

  def put_admin(conn, _params) do
    query = AdminQuery.find_one(%{id: conn.params["id"]})
    case query do
      nil ->
        conn
          |> put_status(:not_found)
          |> render(ErrorView, "404.json")
      admin ->
        conn |> assign(:admin, admin)
    end
  end

  def update_admin(conn, _admin_params) do
    params = conn.params |> Map.take(@updatable) |> to_atom_keys
    case UpdateAdmin.call(conn.assigns.admin, params) do
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
        |> halt
      {:ok, admin} ->
        conn |> assign(:updated_admin, admin)
    end
  end

  defp register_admin(conn, _options) do
    params = conn.params |> to_atom_keys
    case RegisterAdmin.call(params) do
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
        |> halt
      {:ok, admin} ->
        conn |> assign(:new_admin, admin)
    end
  end

  defp validate_not_delete_self(conn, _options) do
    if conn.assigns.current_admin.id == conn.assigns.admin.id do
      conn
      |> put_status(:unprocessable_entity)
      |> assign(:errors, "Admin cannot delete self.")
      |> render(ErrorView, "422.json")
      |> halt
    else
      conn
    end
  end

end
