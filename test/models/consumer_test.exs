defmodule Playdays.ConsumerTest do
  use Playdays.ModelCase, async: true

  alias Playdays.SecureRandom
  alias Playdays.Consumer
  alias Playdays.Child
  alias Playdays.Device
  alias Playdays.FriendRequest
  alias Playdays.Chatroom
  alias Playdays.Queries.ConsumerQuery


  @valid_devices_attrs [
    %{
      uuid: SecureRandom.uuid,
      fb_access_token: "kgkh3g42kh4g23kh4g2kh34g2kg4k2h4gkh3g4k2h4gk23h4gk2h34gk234gk2h34AndSoOn",
    }
  ]

  @valid_consumer_attrs %{
    name: "consumer1",
    email: "consumer@example.com",
    fb_user_id: "634565435",
    devices: @valid_devices_attrs,
    region_id: 1,
    district_id: 1
  }

  @invalid_email_attrs %{
    email: "invalid",
    fb_user_id: "634565435",
    devices: @valid_devices_attrs
  }
  @missing_device_attrs %{ email: "consumer@example.com" }

  

end
