defmodule Playdays.ReminderTest do
  use Playdays.ModelCase, async: false

  alias Playdays.Reminder

  setup do
    friend_request = create(:friend_request)

    {:ok, friend_request: friend_request}
  end

  test "changeset with valid attributes", %{ friend_request: friend_request} do
    valid_attrs = %{
      consumer_id: friend_request.requestee.id,
      friend_request_id: friend_request.id,
      reminder_type: "friendRequestReminder",
    }
    changeset = Reminder.changeset(%Reminder{}, valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes", %{ friend_request: friend_request} do
    invalid_attrs = %{
      friend_request_id: friend_request.id,
      reminder_type: "friendRequestReminder",
    }
    changeset = Reminder.changeset(%Reminder{}, invalid_attrs)
    refute changeset.valid?
  end
end
