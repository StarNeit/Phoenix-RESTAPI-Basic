defmodule Playdays.Services.Consumer.ChatMessage.CreateChatMessageTest do
  use Playdays.ModelCase, async: false

  alias Playdays.Repo
  alias Playdays.Chatroom
  alias Playdays.Services.Consumer.Chatroom.CreateChatroom
  alias Playdays.Services.Consumer.ChatMessage.CreateChatMessage

  setup do
    consumer = create(:consumer)
    another_consumer = create(:consumer)
    consumer_ids = [consumer.id, another_consumer.id]
    { :ok, chatroom } = CreateChatroom.call(%{name: "test", consumer_ids: consumer_ids})
    consumer = consumer |> Repo.preload(:chat_participations)

    {:ok, consumer: consumer, chatroom: chatroom}
  end

  test "create chat message", %{consumer: consumer, chatroom: chatroom} do
    chat_participation = hd consumer.chat_participations
    { state, chat_message } = CreateChatMessage.call(%{chat_participation: chat_participation, chatroom: chatroom, text_content: "test"})

    assert state == :ok

    chat_message = chat_message |> Repo.preload(:chat_participation)

    assert chat_message.id
    assert chat_message.chat_participation.consumer_id == consumer.id
  end
end
