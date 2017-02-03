defmodule Playdays.Services.Consumer.Chatroom.CreateChatroomTest do
  use Playdays.ModelCase, async: false

  alias Playdays.Repo
  alias Playdays.Services.Consumer.Chatroom.CreateChatroom


  test "create chatroom" do
    consumer = create(:consumer)
    another_consumer = create(:consumer)
    consumer_ids = [consumer.id, another_consumer.id]
    { state, chatroom } = CreateChatroom.call(%{name: "test", consumer_ids: consumer_ids})

    assert state == :ok

    chatroom = chatroom |> Repo.preload(:chat_participations)
    chat_participation_count = length chatroom.chat_participations

    assert chat_participation_count == 2

    consumer = consumer |> Repo.preload(:chatrooms)
    consumer_chatrooms_count = length consumer.chatrooms
    another_consumer = another_consumer |> Repo.preload(:chatrooms)
    another_consumer_chatrooms_count = length another_consumer.chatrooms

    assert consumer_chatrooms_count == 1
    assert another_consumer_chatrooms_count == 1
  end
end
