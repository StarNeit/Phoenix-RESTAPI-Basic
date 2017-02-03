defmodule Playdays.Test.Services.Consumer.Consumer.VerifyConsumerAccessTokenTest do
  use Playdays.ModelCase, async: false
  import Mock
  alias Playdays.FBGraphAPIClient
  alias Playdays.Services.Consumer.Consumer.VerifyConsumerAccessToken

  setup do
    consumer = create(:consumer)
    { :ok, consumer: consumer }
  end

  test "create consumer with valid attributes", %{consumer: consumer} do
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
                "user_id": consumer.fb_user_id
              }
            }
          }
        }
      end] do
        device = hd(consumer.devices)
        { status, consumer } = VerifyConsumerAccessToken.call(%{
                                  fb_user_id: consumer.fb_user_id,
                                  device_uuid: device.uuid,
                                  fb_access_token: "new_access_token"
                                })
        assert status == :ok
        assert hd(consumer.devices).fb_access_token == "new_access_token"
    end
  end

  test "create consumer with unknown unknown fb user id should return {:error, reason}" do
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
      consumer = create(:consumer)
      device = hd(consumer.devices)

      { status, reason } = VerifyConsumerAccessToken.call(%{
                                  fb_user_id: "unknown_fb_user_id",
                                  device_uuid: device.uuid,
                                  fb_access_token: "new_access_token"
                                })

      assert status == :error
      assert reason == :unknown_fb_user_id
    end
  end
end
