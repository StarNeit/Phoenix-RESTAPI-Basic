defmodule Playdays.Api.V1.Consumer.VerifyAccessTokenControllerTest do
  use Playdays.ConnCase, async: false
  import Mock
  import Playdays.Utils.MapUtils
  alias Playdays.FBGraphAPIClient

  setup do

    conn = conn()
            |> put_req_header("accept", "application/json")
    consumer = create(:consumer)
    {:ok, conn: conn, consumer: consumer}
  end

  test "consumer verify access token with fb_user_id and fb_access_token successfully", %{conn: conn, consumer: consumer} do
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
        data = %{
          fb_user_id: consumer.fb_user_id,
          fb_access_token: "mock_valid_user_access_token"
        }

        conn = post(conn, api_v1_consumer_verify_access_token_path(conn, :create), data)


        consumer = conn.assigns.consumer

        expected_data = %{
          user_id: consumer.id,
          fb_user_id: consumer.fb_user_id,
          is_valid: true,
          me: %{
            id: consumer.id,
            name: consumer.name,
            email: consumer.email,
            about_me: consumer.about_me,
            fb_user_id: consumer.fb_user_id,
            languages: consumer.languages,
            mobile_phone_number: consumer.mobile_phone_number,
            children: Enum.map(
              consumer.children,
              &%{id: &1.id, birthday: &1.birthday}
            ),
            device: %{
              uuid: hd(consumer.devices).uuid,
              fb_access_token: hd(consumer.devices).fb_access_token,
            },
            region: %{
              name: consumer.region.name,
              id: consumer.region.id,
            },
            district: %{
              id: consumer.district.id,
              name: consumer.district.name,
              region_id: consumer.district.region_id,
            }
          }
        }

        response_data = json_response(conn, 201)["data"] |> to_atom_keys

        assert conn.status == 201
        assert response_data == expected_data
    end
  end

  test "consumer cannot login with invalid fb_access_token", %{conn: conn, consumer: consumer} do
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
      data = %{
        fb_user_id: consumer.fb_user_id,
        fb_access_token: "invalid acess_token"
      }

      conn |> post(api_v1_consumer_verify_access_token_path(conn, :create), data)
           |> assert_status(401)
    end
  end

  test "consumer cannot login with invalid fb_user_id", %{conn: conn, consumer: consumer} do
    data = %{
      fb_user_id: "invalid",
      fb_access_token: hd(consumer.devices).fb_access_token
    }

    conn |> post(api_v1_consumer_verify_access_token_path(conn, :create), data)
         |> assert_status(401)
  end
end
