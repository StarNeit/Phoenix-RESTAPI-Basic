defmodule Playdays.Plugs.Api.AuthenticatedMember do
  use Phoenix.Controller
  import Plug.Conn
  import Ecto.Query

  alias Playdays.Member
  alias Playdays.Queries.MemberQuery

  def init(options) do
    options
  end

  def call(conn, options) do
    device_uuid = get_device_uuid(conn)
    user_id = get_user_id(conn)
    access_token = get_access_token(conn)
    member = MemberQuery.find_one(%{id: user_id})
    result = validate_member(member, device_uuid, access_token)
    case result do
      :invalid_device_uuid ->
        conn
        |> put_status(:unauthorized)
        |> render(Playdays.ErrorView, "401.json", %{message: "Missing valid device uuid"})
        |> halt
      :invalid_access_token ->
        conn
        |> put_status(:unauthorized)
        |> render(Playdays.ErrorView, "401.json", %{message: "Invalid Access Token"})
        |> halt
      { :authenticated, resource } ->
        conn
        |> assign(:current_consumer, resource)
    end
  end

  defp valid_access_token?(member, device_uuid) do
    consu
  end

  defp validate_member(member, device_uuid, access_token) do
    devices = member.devices |> Enum.filter(fn(x) -> x.uuid == device_uuid end)
    device = case (length devices) do
      0 ->
        nil
      x when x > 0 ->
        hd(devices)
    end

    cond do
      #device == nil ->
      #  :invalid_device_uuid
      #device.fb_access_token != access_token ->
      #  :invalid_access_token
      true ->
        { :authenticated, member }
    end
  end

  defp get_device_uuid(conn) do
    List.first(get_req_header(conn, "x-device-uuid"))
  end

  defp get_user_id(conn) do
    List.first(get_req_header(conn, "x-user-id"))
  end

  defp get_access_token(conn) do
    List.first(get_req_header(conn, "x-access-token"))
  end
end
