defmodule Playdays.FBGraphAPIClient do
  use HTTPoison.Base
  import Playdays.Utils.MapUtils

  @expected_fields ~w(
    data application app_id user_id expires_at is_valid scopes
  )

  def process_url(url) do
    env = Application.get_env(:playdays, __MODULE__)
    host = env[:host]
    version = env[:api_version]

    "https://#{host}/v#{version}" <> url
  end

  defp process_request_body(body) do
    body = body
            |> Poison.encode!
    body
  end

  defp process_response_body(body) do
    body = body
            |> Poison.decode!
            |> Dict.take(@expected_fields)
            |> to_atom_keys
    body
  end

  defp process_request_headers(headers) when is_map(headers) do
    Enum.into(headers, [{"Content-Type", "application/json"}])
  end

  defp process_request_headers(headers), do: headers


  defp process_status_code(status_code) do
    status_code
  end

  def debug_token(input_token) do
    headers = []
    access_token = Application.get_env(:playdays, Playdays.FBGraphAPIClient)[:app_token]
    url = "/debug_token?access_token=#{access_token}&input_token=#{input_token}"
    __MODULE__.start
    __MODULE__.get(url, headers, [connect_timeout: 30000, recv_timeout: 30000, timeout: 30000])
  end
end
