defmodule Playdays.TimeSlotTest do
  use Playdays.ModelCase

  alias Playdays.TimeSlot

  @valid_attrs %{
    date: 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now),
    from: 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now),
    to: 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now),
  }

  test "changeset with valid ISOz timestring" do
    changeset = TimeSlot.changeset(%TimeSlot{}, @valid_attrs)
    assert changeset.valid?
  end

end
