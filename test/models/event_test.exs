defmodule Playdays.EventTest do
  use Playdays.ModelCase

  alias Playdays.Event

  @required_fields [:name, :location_address, :price_range]

  @valid_attrs %{
    name: "some content",
    website_url: "www.example.com",
    location_address: "some place maybe, i dont know",
    price_range: %{lo: 100, hi: 150},
    description: "some content",
    contact_number: "12346544",
    image: "www.noimage.yet",
    lat: "22.3231990",
    long: "22.3231379",
    time_slots: [%{date: 1460437072000, from: 1460516272000, to: 1460545072000}]
  }

  test "changeset with valid attributes" do
    changeset = Event.changeset(%Event{}, @valid_attrs)
    assert changeset.valid?
  end

  test "event changeset with empty name should be invalid" do
    attrs = Map.merge @valid_attrs, %{name: ""}
    changeset = Event.changeset(%Event{}, attrs)
    refute changeset.valid?
    assert changeset.errors[:name] == {"can't be blank", []}
  end

  test "insert tag" do
    event = create(:event) |> Repo.preload(:event_tags)
    event_tag = create(:event_tag)

    event_tags = event.event_tags ++ [event_tag]
    event_tags_changeset = Enum.map(event_tags, &Ecto.Changeset.change/1)
    { status, event } = event
                  |> Ecto.Changeset.change
                  |> Ecto.Changeset.put_assoc(:event_tags, event_tags_changeset)
                  |> Repo.update

    event_tags_count = length event.event_tags
    assert status == :ok
    assert event.event_tags
    assert event_tags_count == 1
  end

  # test "insert additional tag" do
  #   place = create(:place) |> Repo.preload(:tags)
  #   tag = create(:tag)
  #
  #   tags = place.tags ++ [tag]
  #   tags_changeset = Enum.map(tags, &Ecto.Changeset.change/1)
  #   { :ok, place } = place
  #                           |> Ecto.Changeset.change
  #                           |> Ecto.Changeset.put_assoc(:tags, tags_changeset)
  #                           |> Repo.update
  #
  #
  #   additional_tag = create(:tag)
  #
  #   updated_tags = place.tags ++ [additional_tag]
  #   updated_tags_changeset = Enum.map(updated_tags, &Ecto.Changeset.change/1)
  #   { status, updated_place } = place
  #                               |> Ecto.Changeset.change
  #                               |> Ecto.Changeset.put_assoc(:tags, updated_tags_changeset)
  #                               |> Repo.update
  #
  #   tags_count = length updated_place.tags
  #   assert status == :ok
  #   assert updated_place.tags
  #   assert tags_count == 2
  # end

  @required_fields
  |> Enum.each(
    &test "changeset with invalid attributes (empty #{&1})" do
      attrs = Map.drop(@valid_attrs, [unquote(&1)])
      changeset = Event.changeset(%Event{}, attrs)
      refute changeset.valid?
    end
  )

end
