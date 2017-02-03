defmodule Playdays.Api.V1.Consumer.FriendView do
  use Playdays.Web, :view

  alias Playdays.Api.V1.Consumer.ChildView
  alias Playdays.Api.V1.Consumer.RegionView
  alias Playdays.Api.V1.Consumer.DistrictView

  @attrs ~W(id name fb_user_id about_me languages)a

  def render("index.json", %{friends: friends}) do
    %{ data: render_many(friends, __MODULE__, "friend_details.json")}
  end

  def render("show.json", %{friend: friend}) do
    %{ data: render_one(friend, __MODULE__, "friend_details.json") }
  end

  def render("friend_lite.json", %{friend: friend}) do
    friend
    |> _render_lite
  end

  def render("friend_details.json", %{friend: friend}) do
    friend
      |> _render_details
  end

  defp _render_lite(friend) do
    friend
      |> Map.take(@attrs)
  end

  defp _render_details(friend) do
    friend
      |> _render_lite
      |> Map.put(:children, render_many(friend.children, ChildView, "child_details.json"))
      |> Map.put(:region, render_one(friend.region, RegionView, "region_details.json"))
      |> Map.put(:district, render_one(friend.district, DistrictView, "district_details.json"))
  end

end
