defmodule Playdays.Test.Services.Admin.Event.CreateEventTest do
  use Playdays.ModelCase, async: false

  alias Playdays.Services.Admin.Event.CreateEvent
  alias Playdays.Queries.EventQuery

  @valid_time_slots [
    %{
      date: 1460437072000,
      from: 1460516272000,
      to: 1460545072000,
    },
    %{
      date: 1460782672000,
      from: 1460516272000,
      to: 1460545072000,
    },
    %{
      date: 1461041872000,
      from: 1460516272000,
      to: 1460545072000,
    },
  ]

  @valid_register_attr %{
    name: "PaTesCo!",
    website_url: "www.PaTesCo.com",
    location_address: "some where exists, may be, i dont know",
    price_range: %{hi: 122, lo: 100},
    description: "some content",
    contact_number: "12346544",
    image: "no.image.com",
    lat: "22.3231990",
    long: "22.3231379",
    time_slots: @valid_time_slots
  }

  setup do
    create(:event)
    :ok
  end

  test "create event with valid param and time_slots" do
    number_of_event = length(EventQuery.find_all)
    {:ok, _event} = CreateEvent.call(@valid_register_attr)
    assert length(EventQuery.find_all) == number_of_event + 1
  end

  test "create event without time_slots return {:error, changeset}" do
    {:error, _} = CreateEvent.call(@valid_register_attr |> Map.drop([:time_slots]))
  end


end
