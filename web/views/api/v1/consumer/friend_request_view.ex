defmodule Playdays.Api.V1.Consumer.FriendRequestView do
  use Playdays.Web, :view

  alias Playdays.Api.V1.Consumer.UserView

  @attrs ~W(id requester_id requestee_id state)a

  def render("index.json", %{friend_requests: friend_requests}) do
    %{ data: render_many(friend_requests, __MODULE__, "friend_request_details.json")}
  end

  def render("show.json", %{friend_request: friend_request}) do
    %{ data: render_one(friend_request, __MODULE__, "friend_request_details.json") }
  end

  def render("friend_request_details.json", %{friend_request: friend_request}) do
    friend_request
      |> _render
  end

  def _render(friend_request) do
    view = friend_request |> Map.take(@attrs)

    if Ecto.assoc_loaded?(friend_request.requester) do
      view = view |> Map.put(:requester, render_one(friend_request.requester, UserView, "user_details.json"))
    end

    if Ecto.assoc_loaded?(friend_request.requestee) do
      view = view |> Map.put(:requestee, render_one(friend_request.requestee, UserView, "user_details.json"))
    end

    view
  end

end
