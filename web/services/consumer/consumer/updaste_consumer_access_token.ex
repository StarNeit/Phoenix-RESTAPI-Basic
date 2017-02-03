defmodule Playdays.Services.Consumer.Consumer.UpdateConsumerAccessToken do
  require Logger

  alias Playdays.Repo
  alias Playdays.Consumer
  alias Playdays.Device
  alias Playdays.Queries.ConsumerQuery

  def call(%{consumer: consumer, device_uuid: device_uuid, fb_access_token: fb_access_token}) do
    device = consumer |> Consumer.find_device(%{uuid: device_uuid})
    case device do
      nil ->
        new_device = %Device{
          uuid: device_uuid,
          fb_access_token: fb_access_token
        }
        consumer |> Consumer.add_device(new_device) |> Repo.update
      _ ->
        devices_changeset = Enum.map(consumer.devices, fn(device) ->
          device
            |> Device.changeset(%{
                  fb_access_token: fb_access_token
                })
        end)

        consumer
          |> Ecto.Changeset.change
          |> Ecto.Changeset.put_embed(:devices, devices_changeset)
          |> Repo.update
    end
  end
end
