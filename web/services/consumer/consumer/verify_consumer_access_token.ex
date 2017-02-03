defmodule Playdays.Services.Consumer.Consumer.VerifyConsumerAccessToken do
  require Logger

  alias Playdays.Repo
  alias Playdays.Device
  alias Playdays.Queries.ConsumerQuery
  alias Playdays.Consumer.VerifiyFBAccessToken

  def call(%{fb_user_id: fb_user_id, device_uuid: device_uuid, fb_access_token: fb_access_token}) do
    case ConsumerQuery.find_one(%{fb_user_id: fb_user_id}) do
      nil ->
        {:error, :unknown_fb_user_id}
      consumer ->
        cond do
          not valid_fb_access_token?(consumer.fb_user_id, fb_access_token) ->
            { :error, :invalid_fb_access_token }
          true ->
            consumer |> update_device_fb_access_token(device_uuid, fb_access_token)
        end
    end
  end

  defp valid_fb_access_token?(fb_user_id, fb_access_token) do
    case VerifiyFBAccessToken.call(fb_access_token) do
      {:ok, result } ->
        result.is_valid && fb_user_id == result.user_id
      {:error, _} ->
        false
    end
  end

  defp update_device_fb_access_token(consumer, device_uuid, fb_access_token) do
    devices = consumer.devices
    devices_changeset = Enum.map(devices, fn(device) ->
      changeset = device |> Ecto.Changeset.change
      if device.uuid == device_uuid do
        changeset = changeset |> Ecto.Changeset.put_change(:fb_access_token, fb_access_token)
      end
      changeset
    end)

    consumer
      |> Ecto.Changeset.change
      |> Ecto.Changeset.put_embed(:devices, devices_changeset)
      |> Repo.update
  end
end
