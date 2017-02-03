defmodule Playdays.Api.V1.Helper do
  use Playdays.Web, :controller

  alias Playdays.ErrorView

  def assign_or_404(nil, conn, resource_name) do
    conn
    |> put_status(:not_found)
    |> render(ErrorView, "404.json", %{message: "The requested #{resource_name} does not exists"})
    |> halt
  end

  def assign_or_404(resource, conn, resource_name) do
    assign conn, resource_name, resource
  end

end
