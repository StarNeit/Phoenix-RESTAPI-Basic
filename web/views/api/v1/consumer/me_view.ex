defmodule Playdays.Api.V1.Consumer.MeView do
  use Playdays.Web, :view

  alias Playdays.Api.V1.Consumer.ChildView
  alias Playdays.Api.V1.Consumer.RegionView
  alias Playdays.Api.V1.Consumer.DistrictView
  alias Playdays.Api.V1.Consumer.DeviceView

  @attrs ~W(id name email fb_user_id about_me friends_count languages mobile_phone_number)a

  def render("show.json", %{me: me}) do
    %{ data: render_one(me, __MODULE__, "me.json") }
  end


  def render("me.json", %{me: me}) do
    me
    |> _render
  end

  def _render(me) do
    me
    |> Map.take(@attrs)
    |> Map.put(:device, render_one(hd(me.devices), DeviceView, "device.json"))
    |> Map.put(:children, render_many(me.children, ChildView, "child_details.json"))
    |> Map.put(:region, render_one(me.region, RegionView, "region_details.json"))
    |> Map.put(:district, render_one(me.district, DistrictView, "district_details.json"))
  end

end
