defmodule Playdays.Api.V1.Consumer.MemberView do
  use Playdays.Web, :view

  alias Playdays.Api.V1.Consumer.ChildView
  alias Playdays.Api.V1.Consumer.RegionView
  alias Playdays.Api.V1.Consumer.DistrictView

  @attrs ~W(id email fname lname about_me token region_id district_id languages children mobile_phone_number password like_events like_places)a

  def render("show.json", %{member: member}) do
    %{ data: render_one(member, __MODULE__, "member.json") }
  end

  def render("member.json", %{member: member}) do
    member
      |> _render
  end

  def render("error.json", _anything) do
    %{errors: "failed to authenticate"}
  end

  def _render(member) do
    view = member
      |> Map.take(@attrs)
      #|> Map.put(:children, render_many(member.children, ChildView, "child_details.json"))

    #if Ecto.assoc_loaded?(member.region_id) do
    #  view = view |> Map.put(:region, render_one(member.region_id, RegionView, "region_details.json"))
    #end
    #if Ecto.assoc_loaded?(member.district_id) do
    #  view = view |> Map.put(:district, render_one(member.district_id, DistrictView, "district_details.json"))
    #end

    view
  end

end
