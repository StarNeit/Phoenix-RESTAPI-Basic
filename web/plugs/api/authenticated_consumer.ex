defmodule Playdays.Plugs.Api.AuthenticatedConsumer do
  use Phoenix.Controller
  import Plug.Conn
  import Ecto.Query

  alias Playdays.Consumer
  alias Playdays.Queries.ConsumerQuery

  def init(options) do
    options
  end

  def call(conn, options) do
    device_uuid = get_device_uuid(conn)
    fb_user_id = get_fb_user_id(conn)
    fb_access_token = get_fb_access_token(conn)
    consumer = ConsumerQuery.find_one(%{fb_user_id: fb_user_id})
    result = validate_consumer(consumer, device_uuid, fb_access_token)
    case result do
      :invalid_device_uuid ->
        conn
        |> put_status(:unauthorized)
        |> render(Playdays.ErrorView, "401.json", %{message: "Missing valid device uuid"})
        |> halt
      :invalid_fb_access_token ->
        conn
        |> put_status(:unauthorized)
        |> render(Playdays.ErrorView, "401.json", %{message: "Invalid FB Access Token"})
        |> halt
      { :authenticated, resource } ->
        conn
        |> assign(:current_consumer, resource)
    end
  end

  defp valid_fb_access_token?(consumer, device_uuid) do
    consu
  end

  defp validate_consumer(consumer, device_uuid, fb_access_token) do
    devices = consumer.devices |> Enum.filter(fn(x) -> x.uuid == device_uuid end)
    device = case (length devices) do
      0 ->
        nil
      x when x > 0 ->
        hd(devices)
    end

    cond do
      device == nil ->
        :invalid_device_uuid
      device.fb_access_token != fb_access_token ->
        :invalid_fb_access_token
      true ->
        { :authenticated, consumer }
    end
  end

  defp get_device_uuid(conn) do
    List.first(get_req_header(conn, "x-device-uuid"))
  end

  defp get_fb_user_id(conn) do
    List.first(get_req_header(conn, "x-fb-user-id"))
  end

  defp get_fb_access_token(conn) do
    List.first(get_req_header(conn, "x-fb-access-token"))
  end
end
