defmodule Playdays.PushNotificationClient.Config do
  defstruct server_url: "http://localhost:9292",
            use_apn_production_gateway: false,
            gcm_api_key: "",
            apn_cert_path: ""
  # sample config
  #
  # config :playdays, Playdays.PushNotificationClient,
  #   server_url: "http://localhost:9292",
  #   use_apn_production_gateway: false,

  def create do
    config = Application.get_env(:playdays, Playdays.PushNotificationClient)

    List.foldl(config, %Playdays.PushNotificationClient.Config{}, fn ({k, v}, acc) ->
      case k do
        :server_url ->
          %{acc | server_url: v}
        :use_apn_production_gateway ->
          %{acc | use_apn_production_gateway: v}
        :gcm_api_key ->
          %{acc | gcm_api_key: v}
        :apn_cert_path ->
          %{acc | apn_cert_path: v}
      end
    end)
  end

  def ios_endpoint(config) do
    "#{config.server_url}/ios_notifications"
  end

  def android_endpoint(config) do
    "#{config.server_url}/android_notifications"
  end
end
