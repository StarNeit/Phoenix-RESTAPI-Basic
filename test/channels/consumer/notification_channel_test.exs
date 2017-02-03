defmodule Playdays.Consumer.NotificationChannelTest do
  use Playdays.ChannelCase


  alias Playdays.Queries.SessionQuery
  alias Playdays.Queries.ReminderQuery
  alias Playdays.Services.Admin.TrialClass.ApproveSession
  alias Playdays.Services.Admin.TrialClass.RejectSession
  alias Playdays.Services.Consumer.FriendRequest.CreateFriendRequest
  alias Playdays.Services.Consumer.FriendRequest.AcceptFriendRequest
  alias Playdays.Services.Consumer.Chatroom.CreateChatroom
  alias Playdays.Services.Consumer.Chatroom.JoinChatroom
  alias Playdays.Api.V1.Consumer.FriendRequestView
  alias Playdays.Api.V1.Consumer.ChatroomView
  alias Playdays.Api.V1.Consumer.SessionView
  alias Playdays.Api.V1.Consumer.ReminderView
  alias Playdays.Consumer.NotificationChannel

  setup do
    consumer = create(:consumer)
    another_consumer = create(:consumer)
    consumer |> join_consumer_notification_channel
    another_consumer |> join_consumer_notification_channel

    {:ok, consumer: consumer, another_consumer: another_consumer}
  end


  test "call new_friend_request_created fn  should broadcast", %{consumer: consumer, another_consumer: another_consumer} do
    { :ok, {friend_request, _reminder} } = CreateFriendRequest.call(%{requester: consumer, requestee: another_consumer})

    NotificationChannel.new_friend_request_created(friend_request)

    _data = FriendRequestView.render("show.json", %{friend_request: friend_request})

    assert_broadcast "friend_request:created", _data
  end

  test "call friend_request_accepted fn  should broadcast", %{consumer: consumer, another_consumer: another_consumer} do
    { :ok, {friend_request, _reminder} } = CreateFriendRequest.call(%{requester: consumer, requestee: another_consumer})
    {:ok, {friend_request, _reminder} } = AcceptFriendRequest.call(%{request: friend_request, requester: consumer, requestee: another_consumer})

    NotificationChannel.friend_request_accepted(friend_request)

    _data = FriendRequestView.render("show.json", %{friend_request: friend_request})

    assert_broadcast "friend_request:accepted", _data
  end

  test "call new_chatroom_created fn should broadcast", %{consumer: consumer, another_consumer: another_consumer} do
    consumer_ids = [consumer.id, another_consumer.id]
    { :ok, chatroom } = CreateChatroom.call(%{name: "test", consumer_ids: consumer_ids})
    chatroom = chatroom |> Repo.preload(chat_participations: [:consumer], chat_messages: [chat_participation: [:consumer]])
    consumer = consumer |> Repo.preload(:chat_participations)
    chat_participation = hd consumer.chat_participations
    chatroom = %{ chatroom | current_chat_participation: chat_participation }
    _data = ChatroomView.render("show.json", %{ chatroom: chatroom })
    NotificationChannel.new_chatroom_created(chatroom)

    assert_broadcast "chatroom:created", _data
  end

  test "call new_chat_participation_joined fn should broadcast", %{consumer: consumer, another_consumer: another_consumer} do

    consumer_ids = [consumer.id, another_consumer.id]
    { :ok, chatroom } = CreateChatroom.call(%{name: "test", consumer_ids: consumer_ids})
    new_consumer = create(:consumer)
    new_consumer |> join_consumer_notification_channel

    { :ok, updated_chatroom } = JoinChatroom.call(%{chatroom: chatroom, new_consumer_id: new_consumer.id})
    consumer = consumer |> Repo.preload(:chat_participations)
    updated_chatroom = updated_chatroom |> Repo.preload(chat_participations: [:consumer], chat_messages: [chat_participation: [:consumer]])
    chat_participation = hd consumer.chat_participations
    updated_chatroom = %{ updated_chatroom | current_chat_participation: chat_participation}
    _data = ChatroomView.render("show.json", %{ chatroom: updated_chatroom })
    NotificationChannel.new_chat_participation_joined(updated_chatroom, new_consumer.id)

    assert_broadcast "chat_participation:new_joined", _data
  end

  test "call session_approved fn  should broadcast", %{consumer: consumer} do
    time_slot = hd create(:trial_class).time_slots
    session = create(:session, time_slot: time_slot, consumer: consumer)

    session = SessionQuery.find_one(%{id: session.id}, preload: [time_slot: :trial_class])

    ApproveSession.call(session)

    NotificationChannel.session_approved(session)

    data = SessionView.render("show.json", %{session: session})

    assert_broadcast "session:approved", data
  end

  test "call session_rejected fn  should broadcast", %{consumer: consumer} do
    time_slot = hd create(:trial_class).time_slots
    session = create(:session, time_slot: time_slot, consumer: consumer)

    session = SessionQuery.find_one(%{id: session.id}, preload: [time_slot: :trial_class])

    RejectSession.call(session)

    NotificationChannel.session_rejected(session)

    data = SessionView.render("show.json", %{session: session})

    assert_broadcast "session:rejected", data
  end

  test "call new_reminder_created fn  should broadcast", %{consumer: consumer, another_consumer: another_consumer} do
    { :ok, {_, %{id: id}} } = CreateFriendRequest.call(%{requester: another_consumer, requestee: consumer})

    reminder = ReminderQuery.by_id id

    NotificationChannel.new_reminder_created reminder

    payload = ReminderView.render("show.json", %{reminder: reminder})

    assert_broadcast "reminder:created", payload
  end

  defp join_consumer_notification_channel(consumer) do
    topic = "consumer_notifications:#{Integer.to_string(consumer.id)}"
    payload = %{}
    socket(consumer.id, %{})
      |> subscribe_and_join(NotificationChannel, topic, payload)
  end
end
