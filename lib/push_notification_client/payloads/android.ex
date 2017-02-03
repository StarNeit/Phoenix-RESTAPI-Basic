defmodule Playdays.PushNotificationClient.Payloads.Android do
  # @derive [Access]
  defstruct notification_title: "New Alert!",
            notification_body: "Description about the alert",
            notification_icon: "icon_name",
            content_available: true,
            data: %{}
end
