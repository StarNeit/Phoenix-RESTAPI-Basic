defmodule Playdays.Api.V1.Consumer.DeviceView do
  use Playdays.Web, :view

  @attrs ~W(fb_access_token uuid)a

  def render("show.json", %{device: device}) do
    %{
      data: render_one(device, __MODULE__, "device.json")
    }
  end

  def render("device.json", %{device: device}) do
    device
      |> _render_lite
  end

  def _render_lite(device) do
    device
      |> Map.take(@attrs)
  end

end
