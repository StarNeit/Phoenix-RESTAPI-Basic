defmodule Playdays.Api.V1.Consumer.VerifyAccessTokenController do
  use Playdays.Web, :controller

  import Playdays.Utils.MapUtils
  alias Playdays.Services.Consumer.Consumer.VerifyConsumerAccessToken
  alias Playdays.Services.Consumer.Consumer.UpdateConsumerAccessToken
  alias Playdays.Repo


  plug :authenticate when action in [:create]


  def create(conn, _) do
    conn
    |> put_status(:created)
    |> render("show.json", consumer: conn.assigns.consumer)
  end

  def authenticate(conn, _options) do
    device_uuid = conn |> get_req_header("x-device-uuid") |> List.first
    fb_access_token = conn.params["fb_access_token"]
    params = %{
      device_uuid: device_uuid,
      fb_user_id: conn.params["fb_user_id"],
      fb_access_token: fb_access_token
    }
    case VerifyConsumerAccessToken.call(params) do
      {:error, :unknown_fb_user_id} ->
        conn
        |> send_resp(401, "Unknown fb user id")
        |> halt
      {:error, :invalid_fb_access_token} ->
        conn
        |> send_resp(401, "Unknown fb access token")
        |> halt

      {:ok, consumer} ->
        UpdateConsumerAccessToken.call(%{consumer: consumer, device_uuid: device_uuid, fb_access_token: fb_access_token})
        assign(conn, :consumer, preload_for_render(consumer) )
    end
  end

  defp preload_for_render(consumer) do
    Repo.preload consumer, [:region, :district]
  end


end
