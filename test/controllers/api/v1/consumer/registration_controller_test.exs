defmodule Playdays.Api.V1.Consumer.RegistrationControllerTest do
  use Playdays.ConnCase, async: false
  import Mock

  import Playdays.Utils.MapUtils

  alias Playdays.FBGraphAPIClient
  alias Playdays.SecureRandom
  alias Playdays.Consumer

  setup do
    region = create(:region)
    district = create(:district, %{region: region})
    conn = conn()
            |> put_req_header("accept", "application/json")
    {:ok, conn: conn, region: region, district: district}
  end

  test "consumer register with email and devices successfully", %{conn: conn, region: region, district: district} do
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
                "expires_at": "12312312312",
                "is_valid": true,
                "scopes": [
                  "user_friends",
                  "email",
                  "public_profile"
                ],
                "user_id": "634565435"
              }
            }
          }
        }
    end] do
      conn = conn
              |> put_req_header("fb_user_id", "634565435")
              |> put_req_header("fb_access_token", "mock_valid_user_access_token")

        data = %{
          name: "consumer",
          email: "consumer@example.com",
          about_me: "a text about me",
          region_id: region.id,
          district_id: district.id,
          mobile_phone_number: "90939102",
          languages: ["abc"],
        }
        uuid = SecureRandom.uuid
        conn = conn
                |> put_req_header("x-device-uuid", uuid)
                |> put_req_header("x-fb-user-id", "634565435")
                |> put_req_header("x-fb-access-token", "mock_valid_user_access_token")


        conn = post(conn, api_v1_consumer_registration_path(conn, :create), data)

        response_data = json_response(conn, 201)["data"] |> to_atom_keys

        consumer = conn.assigns.current_consumer

        expected_data = %{
          id: consumer.id,
          name: data.name,
          email: data.email,
          about_me: data.about_me,
          fb_user_id: "634565435",
          children: [],
          languages: data.languages,
          mobile_phone_number: data.mobile_phone_number,
          device: %{
            uuid: uuid,
            fb_access_token: "mock_valid_user_access_token",
          },
          region: %{
            name: region.name,
            id: region.id,
          },
          district: %{
            id: district.id,
            name: district.name,
            region_id: district.region_id,
          }
        }


        assert conn.status == 201
        assert response_data == expected_data
    end
  end

  test "consumer register with email, devices and optional params successfully", %{conn: conn, region: region, district: district} do
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
                "expires_at": "12312312312",
                "is_valid": true,
                "scopes": [
                  "user_friends",
                  "email",
                  "public_profile"
                ],
                "user_id": "634565435"
              }
            }
          }
        }
    end] do
      conn = conn
              |> put_req_header("fb_user_id", "634565435")
              |> put_req_header("fb_access_token", "mock_valid_user_access_token")

        data = %{
          name: "consumer",
          email: "consumer@example.com",
          region_id: region.id,
          district_id: district.id,
          children: [%{"birthday" => "2016-04"}],
          mobile_phone_number: "99999999",
          about_me: "!!!!!!!!!!!!",
          languages: ["english", "cantonese"],
        }
        uuid = SecureRandom.uuid
        conn = conn
                |> put_req_header("x-device-uuid", uuid)
                |> put_req_header("x-fb-user-id", "634565435")
                |> put_req_header("x-fb-access-token", "mock_valid_user_access_token")


        conn = post(conn, api_v1_consumer_registration_path(conn, :create), data)


        consumer = conn.assigns.current_consumer

        children_count = length consumer.children
        languages_count = length consumer.languages
        response_data = json_response(conn, 201)["data"] |> to_atom_keys

        expected_data = %{
          id: consumer.id,
          name: data.name,
          email: data.email,
          about_me: data.about_me,
          languages: data.languages,
          mobile_phone_number: data.mobile_phone_number,
          children: [
            %{
              id: hd(response_data.children).id,
              birthday: hd(data.children)["birthday"]
            }
          ],
          region: %{
            name: region.name,
            id: region.id,
            },
          district: %{
            id: district.id,
            name: district.name,
            region_id: district.region_id,
          },
          fb_user_id: "634565435",
          device: %{
            uuid: uuid,
            fb_access_token: "mock_valid_user_access_token",
          }
        }
        assert hd(response_data.children).id !== nil
        assert hd(response_data.children).id !== ""

        assert conn.status == 201
        assert response_data == expected_data
        assert children_count == 1
        assert consumer.mobile_phone_number != nil
        assert consumer.about_me != nil
        assert languages_count == 2
    end
  end

  test "consumer register with invalid email", %{conn: conn} do
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
      conn = conn
              |> put_req_header("x-device-uuid", SecureRandom.uuid)
              |> put_req_header("x-fb-user-id", "634565435")
              |> put_req_header("x-fb-access-token", "mock_valid_user_access_token")

      data = %{"email" => "invalid", "children" => [%{"birtday" => "2016-04"}]}

      conn |> post(api_v1_consumer_registration_path(conn, :create), data)
           |> assert_status(422)
    end
  end

  test "consumer register with existed email", %{conn: conn} do
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
      uuid = SecureRandom.uuid
      consumer = %Consumer{
                    email: "exist@example.com",
                    fb_user_id: "108205176247884",
                    devices: [
                      %{
                        uuid: uuid,
                        fb_access_token: "kgkh3g42kh4g23kh4g2kh34g2kg4k2h4gkh3g4k2h4gk23h4gk2h34gk234gk2h34AndSoOn"
                      }
                    ]
                  }
                 |> Repo.insert!
       conn = conn
               |> put_req_header("x-device-uuid", SecureRandom.uuid)
               |> put_req_header("x-fb-user-id", "108205176247884")
               |> put_req_header("x-fb-access-token", "mock_valid_user_access_token")

      data = %{
        email: consumer.email
      }

      conn |> post(api_v1_consumer_registration_path(conn, :create), data)
           |> assert_status(422)
    end
  end

  test "consumer register with invalid fb_access_token", %{conn: conn} do
    data = %{
      name: "consumer",
      email: "consumer@example.com",
      fb_user_id: "634565435",
      fb_access_token: "invalid"
    }

    conn |> post(api_v1_consumer_registration_path(conn, :create), data)
         |> assert_status(422)
  end
end
