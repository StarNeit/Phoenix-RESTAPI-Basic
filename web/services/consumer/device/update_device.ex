defmodule Playdays.Services.Consumer.Device.UpdateDevice do

  alias Playdays.Repo
  alias Playdays.Consumer
  alias Playdays.Device

  def call(%{consumer: consumer, device: device, device_token: device_token, platform: platform}) do
    devices = consumer.devices
    devices_changeset = Enum.map(devices, fn(d) ->
      if (d.uuid == device.uuid) do
        d |> Device.changeset(%{
              device_token: device_token,
              platform: platform
            })
      else
        d |> Ecto.Changeset.change
      end
    end)

    changeset = consumer
                |> Ecto.Changeset.change
                |> Ecto.Changeset.put_embed(:devices, devices_changeset)
    case changeset |> Repo.update do
      {:ok, consumer} ->
        update_device = consumer |> Consumer.find_device(%{uuid: device.uuid})
        {:ok, update_device}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

end
