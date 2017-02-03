defmodule Playdays.Api.V1.Consumer.ChatParticipationControllerTest do
  use Playdays.ConnCase, async: false
  import Playdays.Utils.MapUtils

  alias Playdays.Consumer
  alias Playdays.Chatroom
  alias Playdays.Queries.ChatroomQuery
  alias Playdays.Queries.ChatParticipationQuery
  alias Playdays.Services.Consumer.ChatMessage.CreateChatMessage

  setup do
    consumer = create(:consumer) |> Repo.preload(:friends)
    another_consumer = create(:consumer) |> Repo.preload(:friends)
    consumer |> Consumer.add_friend(another_consumer) |> Repo.update!
    another_consumer |> Consumer.add_friend(consumer) |> Repo.update!
    device = hd(consumer.devices)

    chatroom = %Chatroom{}
                |> Chatroom.changeset(%{
                      name: "test_chatroom",
                      chat_participations: [%{consumer_id: consumer.id}, %{consumer_id: another_consumer.id}]
                    })
                |> Repo.insert!
                |> Repo.preload(chat_participations: [:consumer], chat_messages: [chat_participation: [:consumer]])
    chatroom = ChatroomQuery.find_one(%{id: chatroom.id}, preload: [chat_participations: [:consumer], chat_messages: [chat_participation: [:consumer]]])
    conn = conn()
            |> put_req_header("accept", "application/json")
            |> put_req_header("x-fb-user-id", consumer.fb_user_id)
            |> put_req_header("x-device-uuid", device.uuid)
            |> put_req_header("x-fb-access-token", device.fb_access_token)

    {:ok, conn: conn, consumer: consumer, another_consumer: another_consumer, chatroom: chatroom}
  end

#  test "update chat participation last_read_chat_message_id", %{conn: conn, consumer: consumer, chatroom: chatroom} do
#    consumer = consumer |> Repo.preload(:chat_participations)
#    chat_participation = hd consumer.chat_participations
#    text_content = "test"
#    {:ok, new_message } = CreateChatMessage.call(%{chat_participation: chat_participation, text_content: text_content})
#    data = %{
#      last_read_chat_message_id: new_message.id
#    }
#    conn = put(conn, api_v1_consumer_chat_participation_path(conn, :update, chat_participation), data)
#    assert conn.status == 200
#    chat_participation = conn.assigns.updated_chat_participation
#    expected_data = expected_show_render chat_participation
#    response_data = json_response(conn, 200)["data"] |> to_atom_keys
#    assert response_data == expected_data
#  end

#  test "create chat participation", %{conn: conn, chatroom: chatroom, consumer: consumer, another_consumer: another_consumer} do
#    chatroom =
#      %Chatroom{}
#      |> Chatroom.changeset(%{
#            name: "test_chatroom",
#            chat_participations: [%{consumer_id: consumer.id}, %{consumer_id: another_consumer.id}],
#            is_group_chat: true
#          })
#      |> Repo.insert!

#    new_consumer = create(:consumer)

#    data = %{
#      "consumer_id" => new_consumer.id,
#      "chatroom_id" => chatroom.id,
#    }

#    conn = post(conn, api_v1_consumer_chat_participation_path(conn, :create), data)
#    assert conn.status == 201

#    chat_participation = ChatParticipationQuery.find_many(%{consumer_id: new_consumer.id})
#    assert length(chat_participation) === 1
#    assert hd(chat_participation).chatroom_id === chatroom.id
#  end

  defp expected_show_render(chat_participation) do
    %{
      id: chat_participation.id,
      chatroom_id: chat_participation.chatroom_id,
      consumer_id: chat_participation.consumer_id,
      last_read_chat_message_id: chat_participation.last_read_chat_message_id,
      consumer: %{
        id: chat_participation.consumer.id,
        name: chat_participation.consumer.name,
        fb_user_id: chat_participation.consumer.fb_user_id,
        about_me: chat_participation.consumer.about_me,
        inserted_at: Ecto.DateTime.to_iso8601(chat_participation.consumer.inserted_at),
        updated_at: Ecto.DateTime.to_iso8601(chat_participation.consumer.inserted_at),
      },
      inserted_at: Ecto.DateTime.to_iso8601(chat_participation.inserted_at),
      updated_at: Ecto.DateTime.to_iso8601(chat_participation.inserted_at),
    }
  end
end
