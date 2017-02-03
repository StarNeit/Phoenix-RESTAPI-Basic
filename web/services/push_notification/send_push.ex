defmodule Playdays.Services.PushNotification.SendPush do
  require Logger

  use Playdays.PushNotificationClient.GenServer

  def call(%{
    device: device,
    title: title,
    message: message,
    data: data
  }) do
    case device.platform do
      "iOS" ->
        apn_cert_path = Application.get_env(:playdays, Playdays.PushNotificationClient, [])[:apn_cert_path]
        Logger.info("SendPush::ios::[device_token=#{device.device_token}, apn_cert_path=#{apn_cert_path}]")

        apn_cert = File.read!(apn_cert_path)
        # TODO figure out title in iOS
        composed_message = "#{title}\n\n#{message}"
        notify_ios(%{
          certificate_content: apn_cert,
          device_token: device.device_token,
          payload: %{
            alert: composed_message,
            data: data,
            category: "category" # TODO to be expose
          }
        })
        {:ok, "queued"}
      "Android" ->
        Logger.info("SendPush::android::device_token=#{device.device_token}")
        notify_android(%{
          gcm_api_key: Application.get_env(:playdays, Playdays.PushNotificationClient, [])[:gcm_api_key],
          registration_ids: [device.device_token],
          payload: %{
            notification_body: message,
            notification_title: title,
            notification_icon: "myicon",
            data: data |> Map.merge(%{message: message}),
            collapse_key: "collapse_key", # TODO to be expose
            content_available: true
          }
        })
        {:ok, "queued"}
      unsupported ->
        raise "cannot push to unsupported device type: #{unsupported}"
    end
  end
end
