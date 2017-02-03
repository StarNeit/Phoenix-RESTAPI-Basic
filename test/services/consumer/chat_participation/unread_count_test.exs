defmodule Playdays.Services.Consumer.ChatParticipation.UnreadCountTest do


  use Playdays.ModelCase, async: false

  alias Playdays.Repo
  alias Playdays.ChatParticipation
  alias Playdays.Services.Consumer.Chatroom.CreateChatroom
  alias Playdays.Services.Consumer.ChatMessage.CreateChatMessage
  alias Playdays.Services.Consumer.ChatParticipation.UnreadCount

  setup do
    consumer = create(:consumer)
    another_consumer = create(:consumer)
    consumer_ids = [consumer.id, another_consumer.id]
    { :ok, chatroom } = CreateChatroom.call(%{name: "test", consumer_ids: consumer_ids})
    consumer = consumer |> Repo.preload([:chat_participations, :chat_messages])
    another_consumer = another_consumer |> Repo.preload([:chat_participations, :chat_messages])
    {:ok, consumer: consumer, another_consumer: another_consumer, chatroom: chatroom}
  end

  test "unread count", %{consumer: consumer, another_consumer: another_consumer, chatroom: chatroom} do
    chat_participation = hd consumer.chat_participations
    another_chat_participation = hd another_consumer.chat_participations
    { :ok, chat_message } = CreateChatMessage.call(%{chat_participation: chat_participation, chatroom: chatroom, text_content: "test"})
    { state, unread_count } = UnreadCount.call(%{chat_participation: another_chat_participation})
    assert state == :ok
    assert unread_count == 1
  end

  test "unread count zero after others read all messages", %{consumer: consumer, another_consumer: another_consumer, chatroom: chatroom} do
    chat_participation = hd consumer.chat_participations
    another_chat_participation = hd another_consumer.chat_participations
    { :ok, chat_message } = CreateChatMessage.call(%{chat_participation: chat_participation, chatroom: chatroom, text_content: "test"})
    another_chat_participation = another_chat_participation
      |> ChatParticipation.changeset(%{
            last_read_chat_message_id: chat_message.id
          })
      |> Repo.update!

    { state, unread_count } = UnreadCount.call(%{chat_participation: another_chat_participation})

    assert state == :ok
    assert unread_count == 0
  end

  test "unread count when others read only some messages", %{consumer: consumer, another_consumer: another_consumer, chatroom: chatroom} do
    chat_participation = hd consumer.chat_participations
    another_chat_participation = hd another_consumer.chat_participations
    { :ok, chat_message } = CreateChatMessage.call(%{chat_participation: chat_participation, chatroom: chatroom, text_content: "test1"})
    another_chat_participation = another_chat_participation
      |> ChatParticipation.changeset(%{
            last_read_chat_message_id: chat_message.id
          })
      |> Repo.update!
    CreateChatMessage.call(%{chat_participation: chat_participation, chatroom: chatroom, text_content: "test2"})
    CreateChatMessage.call(%{chat_participation: chat_participation, chatroom: chatroom, text_content: "test3"})
    { state, unread_count } = UnreadCount.call(%{chat_participation: another_chat_participation})

    assert state == :ok
    assert unread_count == 2
  end
end
