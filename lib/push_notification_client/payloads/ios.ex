defmodule Playdays.PushNotificationClient.Payloads.Ios do
  # @derive [Access]
  defstruct alert: "New Alert",
            category: "category",
            content_available: true,
            badge: 1,
            sound: "sound_file",
            data: %{}
end
