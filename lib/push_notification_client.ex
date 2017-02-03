defmodule Playdays.PushNotificationClient do
  require Logger

  alias Playdays.PushNotificationClient.Config
  alias Playdays.PushNotificationClient.Payloads.Ios, as: IosPayload
  alias Playdays.PushNotificationClient.Payloads.Android, as: AndroidPayloadz

  import Playdays.Utils.MapUtils

  def notify_ios(%{
    certificate_content: certificate_content,
    device_token: device_token,
    payload: payload
  }) do

    config = Config.create
    endpoint_url = Config.ios_endpoint(config)
    data = Poison.encode!(%{
      certificate_content: certificate_content,
      device_token: device_token,
      is_production: config.use_apn_production_gateway,
      options: %{
        alert: payload[:alert],
        badge: payload[:badge],
        category: payload[:category],
        content_available: payload[:content_available],
        sound: payload[:sound],
        data: payload[:data],
      }
    })

    HTTPoison.post(endpoint_url, data, headers) |> handle_response
  end

  def notify_android(%{
    gcm_api_key: gcm_api_key,
    registration_ids: registration_ids,
    payload: payload
  }) do

    config = Config.create
    endpoint_url = Config.android_endpoint(config)
    data = Poison.encode!(%{
      api_key: gcm_api_key,
      registration_ids: registration_ids,
      options: %{
        notification: %{
          body: payload[:notification_body],
          title: payload[:notification_title],
          icon: payload[:notification_icon]
        },
        content_available: payload[:content_available],
        data: payload[:data],
      }
    })

    HTTPoison.post(endpoint_url, data, headers) |> handle_response
  end

  defp headers do
    [{"content-type", "application/json"}]
  end

  defp handle_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        Logger.info("Response status code: #{status_code}")
        cond do
          status_code >= 200 && status_code < 300 ->
            {:ok, Poison.decode!(body)}
          true ->
            error_body = Poison.decode!(body) |> to_atom_keys
            {:error, (error_body |> Map.get(:error)) || error_body}
        end
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.info("Response error: #{reason}")
        {:error, reason}
    end
  end
end
