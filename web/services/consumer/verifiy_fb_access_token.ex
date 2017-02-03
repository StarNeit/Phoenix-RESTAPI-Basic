defmodule Playdays.Consumer.VerifiyFBAccessToken do
  require Logger

  alias Playdays.FBGraphAPIClient

  def call(fb_access_token) do
    case FBGraphAPIClient.debug_token(fb_access_token) do
      {:ok, response } ->
        {:ok, response.body.data }
      {:error, response} ->
        Logger.error "FBGraphAPIClient.debug_token request: #{response.reason}"
        {:error, response}
    end
  end
end
