defmodule Playdays.Api.V1.Consumer.UserView do
  use Playdays.Web, :view

  alias Playdays.Api.V1.Consumer.ChildView
  alias Playdays.Api.V1.Consumer.RegionView
  alias Playdays.Api.V1.Consumer.DistrictView

  @attrs ~W(id name fb_user_id about_me)a

  def render("index.json", %{users: users}) do
    %{ data: render_many(users, __MODULE__, "user_details.json")}
  end

  def render("show.json", %{user: user}) do
    %{ data: render_one(user, __MODULE__, "user_details.json") }
  end

  def render("user_details.json", %{user: user}) do
    user
      |> _render
  end

  def _render(user) do
    view = user
      |> Map.take(@attrs)
      |> Map.put(:children, render_many(user.children, ChildView, "child_details.json"))

    if Ecto.assoc_loaded?(user.region) do
      view = view |> Map.put(:region, render_one(user.region, RegionView, "region_details.json"))
    end
    if Ecto.assoc_loaded?(user.district) do
      view = view |> Map.put(:district, render_one(user.district, DistrictView, "district_details.json"))
    end

    view
  end
end
