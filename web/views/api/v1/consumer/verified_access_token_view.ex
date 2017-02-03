defmodule Playdays.Api.V1.Consumer.VerifyAccessTokenView do
  use Playdays.Web, :view

  alias Playdays.Api.V1.Consumer.ChildView
  alias Playdays.Api.V1.Consumer.RegionView
  alias Playdays.Api.V1.Consumer.DistrictView
  alias Playdays.Api.V1.Consumer.DeviceView
  alias Playdays.Api.V1.Consumer.MeView

  @attrs ~W(id fb_user_id name about_me email)a

  def render("show.json", %{consumer: consumer}) do
    %{ data: render_one(consumer, __MODULE__, "verify_access_token.json") }
  end

  def render("verify_access_token.json", %{verify_access_token: consumer}) do
    consumer
      |> _render
  end

  def _render(consumer) do
    %{
      user_id: consumer.id,
      fb_user_id: consumer.fb_user_id,
      is_valid: true,
      me: render_one(consumer, MeView, "me.json")
    }
  end
end
