defmodule Playdays.Factory do
  use ExMachina.Ecto, repo: Playdays.Repo

  alias Playdays.Admin
  alias Playdays.Category
  alias Playdays.Comment
  alias Playdays.Consumer
  alias Playdays.Member
  alias Playdays.District
  alias Playdays.Event
  alias Playdays.FriendRequest
  alias Playdays.Place
  alias Playdays.Region
  alias Playdays.Reminder
  alias Playdays.SecureRandom
  alias Playdays.Session
  alias Playdays.Tag
  alias Playdays.EventTag
  alias Playdays.TimeSlot
  alias Playdays.TrialClass
  alias Playdays.PrivateEvent
  alias Playdays.PrivateEventInvitation
  alias Playdays.PrivateEventParticipation

  def factory(:admin) do
    %Admin{
      email: sequence(:email, &"admin#{&1}@example.com"),
      hashed_password: "PLAINTEXT",
      name: Faker.Name.name,
      authentication_token: SecureRandom.base64(16),
    }
  end

  def factory(:consumer) do
    %Consumer{
      name: Faker.Name.name,
      email: sequence(:email, &"consumer#{&1}@example.com"),
      fb_user_id: SecureRandom.base64(16),
      devices: [
        %{
          device_token: "fake_device_token",
          platform: "iOS",
          uuid: SecureRandom.uuid,
          fb_access_token: SecureRandom.base64(16),
        }
      ],
      region: build(:region),
      district: build(:district),
      about_me: "about me description",
      children: [
        %{
          birthday: "2016-04"
        }
      ]
    }
  end

  def factory(:member) do
    %Member{
      fname: Faker.Name.name,
      lname: Faker.Name.name,
      email: sequence(:email, &"consumer#{&1}@example.com"),
      devices: [
        %{
          device_token: "fake_device_token",
          platform: "iOS",
          uuid: SecureRandom.uuid,
          fb_access_token: SecureRandom.base64(16),
        }
      ],
      region: build(:region),
      district: build(:district),
      about_me: "about me description",
      children: [
        %{
          birthday: "2016-04"
        }
      ]
    }
  end

  def factory(:category) do
    %Category{
      title: sequence(:title, &"category_#{&1}"),
      hex_color_code: sequence(:hex_color_code, &"##{&1}"),
    }
  end

  def factory(:tag) do
    %Tag{
      title: sequence(:title, &"tag#{&1}")
    }
  end

  def factory(:event_tag) do
    %EventTag{
      title: sequence(:title, &"tag#{&1}")
    }
  end

  def factory(:place) do
    %Place{
      name: Faker.Name.name,
      website_url: Faker.Internet.domain_name,
      contact_number: "+85298881111",
      location_address: Faker.Address.street_address,
      description: "description",
      image: "no.image.com",
      is_active: true,
      lat: "test",
      long: "test",
    }
  end

  def factory(:event) do
    %Event{
      name: Faker.Company.name,
      website_url: Faker.Internet.domain_name,
      location_address: Faker.Address.street_address,
      contact_number: "98881111",
      description: Faker.Lorem.paragraph,
      price_range: %{hi: 133, lo: 100},
      image: "no.image.com",
      lat: Faker.format("22.3231###"),
      long: Faker.format("114.1677###"),
      joined_consumer_number: 0,
      time_slots: build_list(3, :time_slot),
      is_active: true,
    }
  end

  def factory(:trial_class) do
    %TrialClass{
      name: Faker.Company.name,
      website_url: Faker.Internet.domain_name,
      location_address: Faker.Address.street_address,
      contact_number: "98881111",
      description: Faker.Lorem.paragraph,
      image: "no.image.com",
      time_slots: build_list(3, :time_slot),
      is_active: true,
    }
  end

  def factory(:time_slot) do
    %TimeSlot{
      date: Ecto.Date.utc,
      from: Ecto.Time.utc,
      to: Ecto.Time.utc
    }
  end

  def factory(:region) do
    %Region{
      name: Faker.Name.name,
      hex_color_code: sequence(:hex_color_code, &"##{&1}"),
    }
  end

  def factory(:district) do
    %District{
      name: Faker.Name.name,
      region: build(:region),
      hex_color_code: sequence(:hex_color_code, &"##{&1}"),
    }
  end

  def factory(:friend_request) do
    %FriendRequest{
      requester: build(:consumer),
      requestee: build(:consumer),
      state: "pending"
    }
  end

  def factory(:session) do
    %Session{
      consumer: build(:consumer),
      status: "pending"
    }
  end

  def factory(:reminder) do
    %Reminder{
      consumer: build(:consumer),
      state: "unread",
    }
  end

  def factory(:private_event) do
    %PrivateEvent{
      name: "test",
      place: build(:place),
      date: Ecto.Date.utc,
      from: Ecto.Time.utc,
      consumer: build(:consumer)
    }
  end

  def factory(:private_event_invitation) do
    %PrivateEventInvitation{
      private_event: build(:private_event),
      consumer: build(:consumer)
    }
  end

  def factory(:private_event_participation) do
    %PrivateEventParticipation{
      private_event: build(:private_event),
      consumer: build(:consumer)
    }
  end

  def factory(:comment) do
    %Comment{
      text_content: Faker.Lorem.paragraph,
      member: build(:member)
    }
  end

end
