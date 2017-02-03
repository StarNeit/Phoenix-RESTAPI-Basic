defmodule Playdays.Services.Consumer.Device.UpdateDeviceTest do
  use Playdays.ModelCase, async: false

  alias Playdays.Repo
  alias Playdays.Services.Consumer.Device.UpdateDevice

  setup do
    consumer = create(:consumer)
    device = hd(consumer.devices)
    {:ok, consumer: consumer, device: device}
  end

  test "consumer can join a session", %{consumer: consumer, device: device} do
    device_token = "fake_device_token"
    platform = "ios"
    {:ok, update_device} = UpdateDevice.call(%{consumer: consumer, device: device, device_token: device_token, platform: platform})

    assert update_device.device_token == device_token
    assert update_device.platform == platform
  end
end
