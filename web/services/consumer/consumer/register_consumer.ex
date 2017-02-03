defmodule Playdays.Services.Consumer.Consumer.RegisterConsumer do

  alias Playdays.Repo
  alias Playdays.Consumer
  alias Playdays.Child

  def call(consumer_params) do
    with(
      {:ok, changeset} <- gen_consumer_changeset(consumer_params),
      {:ok, consumer } <- Repo.insert(changeset),
      do: {:ok, Repo.get_by!(Consumer, id: consumer.id)}
    )
  end

  defp valid_email?(email) do
    email != nil && email != ""
  end

  defp valid_fb_access_token?(fb_user_id, fb_access_token) do
    case Playdays.Consumer.VerifiyFBAccessToken.call(fb_access_token) do
      {:ok, result } ->
        result.is_valid && fb_user_id == result.user_id
      {:error, _} ->
        false
    end
  end

  defp gen_consumer_changeset(data) do
    uuid = data[:device_uuid]
    fb_user_id = data[:fb_user_id]
    fb_access_token = data[:fb_access_token]

    params = Map.merge(data, %{
                devices: [
                  %{
                    uuid: uuid,
                    fb_access_token: fb_access_token,
                  }
                ]
              })
    changeset = %Consumer{}
                  |> Consumer.changeset(params)

    #cond do
    #  not valid_email?(data[:email]) ->
    #    changeset = changeset |> Ecto.Changeset.add_error(:email, "Invalid Email")
    #    { :error, changeset }
    #  not valid_fb_access_token?(fb_user_id, fb_access_token) ->
    #    changeset = changeset |> Ecto.Changeset.add_error(:devices, "Invalid FB Access Token")
    #    { :error, changeset }
    #  true ->
    #    {:ok, changeset }
    #end

    cond do
      true ->
        {:ok, changeset }
    end
  end


end
