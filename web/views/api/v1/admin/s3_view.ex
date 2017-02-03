defmodule Playdays.Api.V1.Admin.S3View do
  use Playdays.Web, :view

  def render("show.json", %{signed_url: signed_url}) do

    %{
      data: %{
        id: 1,
        signed_url: signed_url
      }
    }
  end
end
