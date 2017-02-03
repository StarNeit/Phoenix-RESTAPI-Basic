defmodule Playdays.Services.Consumer.FriendRequest.CreateFriendRequestTest do
  use Playdays.ModelCase, async: false

  alias Playdays.Repo
  alias Playdays.Services.Consumer.FriendRequest.CreateFriendRequest
  alias Playdays.Queries.ReminderQuery

  setup do
    consumer = create(:consumer)
    another_consumer = create(:consumer)
    {:ok, consumer: consumer, another_consumer: another_consumer}
  end


  test "create friend request", %{consumer: consumer, another_consumer: another_consumer} do
    { status, {request, _reminder} } = CreateFriendRequest.call(%{requester: consumer, requestee: another_consumer})

    request = request |> Repo.preload([:requester, :requestee])
    assert status == :ok
    assert request.state == "pending";
    assert request.requester.id
    assert request.requestee.id
  end

  test "fail to create a friend request to same requestee when there is a request with pending state", %{consumer: consumer, another_consumer: another_consumer} do
    pending_friend_request = create(:friend_request, %{requester: consumer, requestee: another_consumer})
    { status, changeset } = CreateFriendRequest.call(%{requester: consumer, requestee: another_consumer})
    assert status == :error
    assert changeset.errors[:state] == {"duplicated", []}
  end

  test "fail to create a friend request to same requestee when there is a request with accept state", %{consumer: consumer, another_consumer: another_consumer}
   do
     pending_friend_request = create(:friend_request, %{requester: consumer, requestee: another_consumer, state: "accepted"})
     { status, changeset } = CreateFriendRequest.call(%{requester: consumer, requestee: another_consumer})
     assert status == :error
     assert changeset.errors[:state] == {"already_accepted", []}
  end

  test "creating a friend request will create reminder", %{consumer: consumer, another_consumer: another_consumer} do
    assert 0 == length ReminderQuery.find_many(%{consumer_id: another_consumer.id})

    { _, {request, _reminder} } = CreateFriendRequest.call(%{requester: consumer, requestee: another_consumer})

    reminders = ReminderQuery.find_many(%{consumer_id: another_consumer.id})
    assert 1 == length reminders
    reminder = hd reminders
    assert reminder.consumer_id == another_consumer.id
    assert reminder.friend_request_id == request.id
    assert reminder.reminder_type == "friendRequestReminder"
  end
end
