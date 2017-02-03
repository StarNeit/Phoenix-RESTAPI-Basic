defmodule Playdays.Api.V1.Admin.AdminView do
  use Playdays.Web, :view

  @attrs ~W(id email name)a

  def render("index.json", %{admins: admins}) do
    %{ data: render_many(admins, __MODULE__, "admin.json") }
  end

  def render("show.json", %{admin: admin}) do
    %{ data: render_one(admin, __MODULE__, "admin.json") }
  end

  def render("admin.json", %{admin: admin}) do
    admin
    |> _render
  end

  defp _render(admin) do
    admin
    |> Map.take(@attrs)
  end

end
