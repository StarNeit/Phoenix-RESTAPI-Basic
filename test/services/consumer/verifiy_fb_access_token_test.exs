defmodule Playdays.Consumer.VerifiyFBAccessTokenTest do
  use Playdays.ModelCase, async: true
  import Mock

  alias Playdays.FBGraphAPIClient
  alias Playdays.Consumer.VerifiyFBAccessToken

  test "verify valid user access token" do
    with_mock FBGraphAPIClient, [
      debug_token: fn(_input_token) ->
        {
          :ok,
          %HTTPoison.Response{
            status_code: 200,
            body: %{
              "data": %{
                "app_id": "1727533490837723",
                "application": "PlayDays - Test1",
                "expires_at": 1459933200,
                "is_valid": true,
                "scopes": [
                  "user_friends",
                  "email",
                  "public_profile"
                ],
                "user_id": "108205176247884"
              }
            }
          }
        }
      end] do
        { status, result } = VerifiyFBAccessToken.call("valid_user_access_token")
        assert status == :ok
        assert result.is_valid == true
    end
  end

  test "failed to verify invalid user access token" do
    with_mock FBGraphAPIClient, [
      debug_token: fn(_input_token) ->
        {
          :ok,
          %HTTPoison.Response{
            status_code: 200,
            body: %{
              "data": %{
                "error": %{
                  "code": 190,
                  "message": "The access token could not be decrypted"
                },
                "is_valid": false,
                "scopes": []
              }
            }
          }
        }
    end] do
      { status, result } = VerifiyFBAccessToken.call("invalid_user_access_token")
      assert status == :ok
      assert result.is_valid == false
    end
  end

  test "failed to verify a expired user access token" do
    with_mock FBGraphAPIClient, [
      debug_token: fn(_input_token) ->
        {
          :ok,
          %HTTPoison.Response{
            status_code: 200,
            body: %{
              "data": %{
                "app_id": "11111111111111",
                "application": "PlayDays - Test1",
                "error": %{
                  "code": 190,
                  "message": "Error validating access token: Session has expired on Tuesday, 05-Apr-16 23:00:00 PDT. The current time is Tuesday, 05-Apr-16 23:55:35 PDT.",
                  "subcode": 463
                },
                "expires_at": 1459922400,
                "is_valid": false,
                "scopes": [
                  "user_friends",
                  "email",
                  "public_profile"
                ],
                "user_id": "108205176247884"
              }
            }
          }
        }
      end] do
      { status, result } = VerifiyFBAccessToken.call("valid_user_access_token")
      assert status == :ok
      assert result.is_valid == false
    end
  end

  test "failed to verify due to timeout" do
    with_mock FBGraphAPIClient, [
      debug_token: fn(_input_token) ->
        { :error, %HTTPoison.Error{ reason: :timeout} }
      end] do
        { status, result } = VerifiyFBAccessToken.call("valid_user_access_token")
        assert status == :error
        assert result.reason == :timeout
    end
  end
end
