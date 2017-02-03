defmodule Playdays.Api.V1.Consumer.RegistrationView do
  use Playdays.Web, :view

  alias Playdays.Api.V1.Consumer.ChildView
  alias Playdays.Api.V1.Consumer.RegionView
  alias Playdays.Api.V1.Consumer.DistrictView
  alias Playdays.Api.V1.Consumer.DeviceView
  alias Playdays.Api.V1.Consumer.MeView

  def render("show.json", %{consumer: consumer}) do
    %{ data: render_one(consumer, MeView, "me.json") }
  end

end
