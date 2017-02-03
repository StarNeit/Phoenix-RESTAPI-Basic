defmodule Playdays.Services.Consumer.FriendRequest.AcceptFriendRequestTest do
  use Playdays.ModelCase, async: false

  alias Playdays.Repo
  alias Playdays.FriendRequest
  alias Playdays.Services.Consumer.FriendRequest.CreateFriendRequest
  alias Playdays.Services.Consumer.FriendRequest.AcceptFriendRequest
  alias Playdays.Queries.ReminderQuery

  setup do
    consumer = create(:consumer)
    another_consumer = create(:consumer)
    {:ok, consumer: consumer, another_consumer: another_consumer}
  end

  test "accept friend request", %{consumer: consumer, another_consumer: another_consumer} do
    { :ok, {request, _reminder} } = CreateFriendRequest.call(%{requester: consumer, requestee: another_consumer})
    { state, {request, _reminder}} = AcceptFriendRequest.call(%{request: request, requester: consumer, requestee: another_consumer})
    consumer = consumer |> Repo.preload(:friends)
    another_consumer = another_consumer |> Repo.preload(:friends)
    consumer_friend_count = length consumer.friends
    another_consumer_friend_count = length another_consumer.friends
    assert state == :ok
    assert request.state == "accpeted";
    assert consumer_friend_count == 1
    assert another_consumer_friend_count == 1
  end

  test "accept friend request will create reminder", %{consumer: consumer, another_consumer: another_consumer} do
    assert 0 == length ReminderQuery.find_many(%{consumer_id: consumer.id})

    { :ok, {request, _reminder} } = CreateFriendRequest.call(%{requester: consumer, requestee: another_consumer})
    { state, {request, _reminder}} = AcceptFriendRequest.call(%{request: request, requester: consumer, requestee: another_consumer})

    reminders = ReminderQuery.find_many(%{consumer_id: consumer.id})
    assert 1 == length reminders
    reminder = hd reminders
    assert reminder.consumer_id == request.requester_id
    assert reminder.friend_request_id == request.id
    assert reminder.reminder_type == "acceptedFriendRequestReminder"
  end

end
