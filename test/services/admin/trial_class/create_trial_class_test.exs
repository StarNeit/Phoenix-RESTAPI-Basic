defmodule Playdays.Test.Services.Admin.TrialClass.CreateTrialClassTest do
  use Playdays.ModelCase, async: false

  alias Playdays.Services.Admin.TrialClass.CreateTrialClass
  alias Playdays.Queries.TrialClassQuery

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
    description: "some content",
    contact_number: "12346544",
    time_slots: @valid_time_slots,
    image: "no.image.com"
  }

  setup do
    create(:trial_class)
    :ok
  end

  test "create trial_class with valid param and time_slots" do
    number_of_trial_class = length(TrialClassQuery.find_all)
    {:ok, _trial_class} = CreateTrialClass.call(@valid_register_attr)
    assert length(TrialClassQuery.find_all) == number_of_trial_class + 1
  end

  test "create trial_class without time_slots return {:error, changeset}" do
    {:error, _} = CreateTrialClass.call(@valid_register_attr |> Map.drop([:time_slots]))
  end


end
