defmodule Playdays.Api.V1.Consumer.LoginView do
  use Playdays.Web, :view
  @attrs ~W(id email fname lname about_me token region_id district_id languages children mobile_phone_number password like_events like_places)a

  def render("show.json", %{login: login}) do
    %{data: render_one(login, __MODULE__, "session.json")}
  end

  def render("session.json", %{login: login}) do
    #%{token: login.token}
    view = login
      |> Map.take(@attrs)
  end

  def render("error.json", _anything) do
    %{errors: "failed to authenticate"}
  end

  def render("logout.json", _anything) do
    %{message: "logout successfully"}
  end
end