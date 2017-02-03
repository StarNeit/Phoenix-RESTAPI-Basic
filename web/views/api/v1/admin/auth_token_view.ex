defmodule Playdays.Api.V1.Admin.AuthTokenView do
  use Playdays.Web, :view

  alias Playdays.Api.V1.Admin.DeviceView

  @attrs ~W(id email auth_token)a

  def render("show.json", %{admin: admin}) do
    %{
      data: %{
        id: admin.id,
        email: admin.email,
        auth_token: admin.authentication_token
      }
    }
  end

end
