defmodule Playdays.Test.Services.Consumer.Consumer.RegisterConsumerTest do
  use Playdays.ModelCase, async: false
  import Mock
  alias Playdays.SecureRandom
  alias Playdays.FBGraphAPIClient
  alias Playdays.Services.Consumer.Consumer.RegisterConsumer


  setup do
    region = create(:region)
    district = create(:district, %{region: region})
    {:ok, region: region, district: district}
  end


  test "create consumer with valid attributes", %{ region: region, district: district} do
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
                "expires_at": 3129033123123,
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
        params = %{
          name: "consumer",
          email: "consumer1@example.com",
          device_uuid: SecureRandom.uuid,
          fb_access_token: "kgkh3g42kh4g23kh4g2kh34g2kg4k2h4gkh3g4k2h4gk23h4gk2h34gk234gk2h34AndSoOn",
          fb_user_id: "108205176247884",
          region_id: region.id,
          district_id: district.id
        }
        { status, consumer } = RegisterConsumer.call(params)
        assert status == :ok
        assert consumer.email == "consumer1@example.com"
    end
  end

  test "create consumer with empty email should return {:error, reason}", %{ region: region, district: district} do
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
      params = %{
        name: "consumer",
        email: "consumer1",
        device_uuid: SecureRandom.uuid,
        fb_access_token: "",
        fb_user_id: "108205176247884",
        region_id: region.id,
        district_id: district.id
      }
      { status, changeset } = RegisterConsumer.call(params)

      assert status == :error
      assert changeset.errors[:email]
    end
  end

  test "create consumer with valid attributes and optional attributes", %{ region: region, district: district} do
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
                "expires_at": 3129033123123,
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
        params = %{
                    name: "consumer",
                    email: "consumer1@example.com",
                    device_uuid: SecureRandom.uuid,
                    fb_access_token: "kgkh3g42kh4g23kh4g2kh34g2kg4k2h4gkh3g4k2h4gk23h4gk2h34gk234gk2h34AndSoOn",
                    fb_user_id: "108205176247884",
                    region_id: region.id,
                    district_id: district.id,
                    children: [%{birthday: "2016-04"}],
                    mobile_phone_number: "99999999",
                    about_me: "!!!!!!!!!!!!!!!!!!!!!!!!!!",
                    languages: ["english", "cantonese"]
                  }

        { status, consumer } = RegisterConsumer.call(params)
        children_count = length consumer.children
        languages_count = length consumer.languages
        assert status == :ok
        assert consumer.email == "consumer1@example.com"
        assert children_count == 1
        assert consumer.mobile_phone_number != nil
        assert consumer.about_me != nil
        assert languages_count == 2
    end
  end
end
