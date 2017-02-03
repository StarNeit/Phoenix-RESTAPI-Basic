defmodule Playdays.Services.Consumer.Chatroom.JoinChatroomTest do
  use Playdays.ModelCase, async: false

  alias Playdays.Repo
  alias Playdays.Services.Consumer.Chatroom.CreateChatroom
  alias Playdays.Services.Consumer.Chatroom.JoinChatroom


  test "join chatroom" do
    consumer = create(:consumer)
    second_consumer = create(:consumer)
    third_consumer = create(:consumer)
    consumer_ids = [consumer.id, second_consumer.id]
    { :ok, chatroom } = CreateChatroom.call(%{name: "test", consumer_ids: consumer_ids})

    { state, updated_chatroom } = JoinChatroom.call(%{chatroom: chatroom, new_consumer_id: third_consumer.id})

    updated_chatroom = updated_chatroom |> Repo.preload(:chat_participations)
    chat_participation_count = length updated_chatroom.chat_participations

    assert chat_participation_count == 3

    consumer = consumer |> Repo.preload(:chatrooms)
    second_consumer = second_consumer |> Repo.preload(:chatrooms)
    third_consumer = third_consumer |> Repo.preload(:chatrooms)
    consumer_chatrooms_count = length consumer.chatrooms
    second_consumer_chatrooms_count = length second_consumer.chatrooms
    third_consumer_chatrooms_count = length third_consumer.chatrooms

    assert consumer_chatrooms_count == 1
    assert second_consumer_chatrooms_count == 1
    assert third_consumer_chatrooms_count == 1
  end
end
