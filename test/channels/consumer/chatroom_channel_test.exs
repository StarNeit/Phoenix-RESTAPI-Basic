defmodule Playdays.Consumer.ChatroomChannelTest do
  use Playdays.ChannelCase

  alias Playdays.Repo
  alias Playdays.Chatroom
  alias Playdays.Api.V1.Consumer.ChatMessageView
  alias Playdays.Services.Consumer.ChatMessage.CreateChatMessage
  alias Playdays.Consumer.ChatroomChannel


  setup do
    consumer = create(:consumer)
    another_consumer = create(:consumer)
    chatroom = %Chatroom{}
                |> Chatroom.changeset(%{
                      name: "test",
                      chat_participations: [
                        %{
                          consumer_id: consumer.id
                        },
                        %{
                          consumer_id: another_consumer.id
                        }
                      ]
                    })
                |> Repo.insert!

    consumer |> join_consumer_chatroom_channel(chatroom)
    another_consumer |> join_consumer_chatroom_channel(chatroom)
    consumer = consumer |> Repo.preload(:chat_participations)
    {:ok, consumer: consumer, another_consumer: another_consumer, chatroom: chatroom}
  end

  test "call new_message_created fn should broadcast", %{consumer: consumer, chatroom: chatroom} do
    chat_participation = hd consumer.chat_participations
    # chatroom = %{ chatroom | current_chat_participation: chat_participation}

    {:ok, chat_message } = CreateChatMessage.call(%{chat_participation: chat_participation, text_content: "DDD"})
    chat_message = chat_message |> Repo.preload(:chat_participation)
    _data = ChatMessageView.render("show.json", %{chat_message: chat_message})

    ChatroomChannel.new_message_created(chat_message)

    assert_broadcast "chatroom:new_message_created", _data
  end

  defp join_consumer_chatroom_channel(consumer, chatroom) do
    topic = "consumer_chatrooms:#{Integer.to_string(chatroom.id)}"
    payload = %{
      consumer_id: consumer.id
    }
    socket(consumer.id, %{})
      |> subscribe_and_join(ChatroomChannel, topic, payload)
  end
end
