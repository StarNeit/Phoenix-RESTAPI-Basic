defmodule Playdays.Api.V1.Consumer.ChatroomControllerTest do
  use Playdays.ConnCase, async: false

  import Playdays.Utils.MapUtils

  alias Playdays.Consumer
  alias Playdays.Chatroom
  alias Playdays.Queries.ChatroomQuery
  alias Playdays.Services.Consumer.Chatroom.CreateChatroom
  alias Playdays.Services.Consumer.ChatParticipation.UnreadCount

  setup do
    consumer = create(:consumer) |> Repo.preload(:friends)
    another_consumer = create(:consumer) |> Repo.preload(:friends)
    consumer |> Consumer.add_friend(another_consumer) |> Repo.update!
    another_consumer |> Consumer.add_friend(consumer) |> Repo.update!
    device = hd(consumer.devices)

    chatroom = %Chatroom{}
                |> Chatroom.changeset(%{
                      name: "test_chatroom",
                      chat_participations: [
                        %{consumer_id: consumer.id}, %{consumer_id: another_consumer.id}
                      ]
                    })
                |> Repo.insert!
                |> Repo.preload(chat_participations: [:consumer], chat_messages: [chat_participation: [:consumer]])
    consumer = consumer |> Repo.preload(:chat_participations)
    chatroom = ChatroomQuery.find_one(%{id: chatroom.id}, preload: [chat_participations: [:consumer], chat_messages: [chat_participation: [:consumer]]])

    conn = conn()
            |> put_req_header("accept", "application/json")
            |> put_req_header("x-fb-user-id", consumer.fb_user_id)
            |> put_req_header("x-device-uuid", device.uuid)
            |> put_req_header("x-fb-access-token", device.fb_access_token)

    {:ok, conn: conn, consumer: consumer, another_consumer: another_consumer, chatroom: chatroom}
  end

#  test "list all chatrooms", %{conn: conn, consumer: consumer, chatroom: chatroom} do
#    chat_participation = hd consumer.chat_participations
#    chatroom = %{ chatroom | current_chat_participation: chat_participation}
#    chatrooms = [chatroom]
#    conn = get(conn, api_v1_consumer_chatroom_path(conn, :index))

#    assert conn.status == 200
#    expected_data = Enum.map(chatrooms, &expected_render/1)
#    response_data = json_response(conn, 200)["data"] |> to_atom_keys

#    assert response_data == expected_data
#  end

#  test "show a chatroom", %{conn: conn, consumer: consumer, chatroom: chatroom} do
#    chat_participation = hd consumer.chat_participations
#    chatroom = %{ chatroom | current_chat_participation: chat_participation}

#    conn = get(conn, api_v1_consumer_chatroom_path(conn, :show, chatroom))
##    assert conn.status == 200
#    expected_data = chatroom |> expected_render
#    response_data = json_response(conn, 200)["data"] |> to_atom_keys

#    assert response_data == expected_data
#  end


#  test "create a one-to-one chatroom", %{conn: conn, consumer: consumer} do
#    new_consumer = create(:consumer)
#    data = %{
#      consumer_id: new_consumer.id
#    }

#    conn = post(conn, api_v1_consumer_chatroom_path(conn, :create), data)
#    assert conn.status == 201
#    chatroom = conn.assigns.new_chatroom
#    expected_data = expected_render chatroom
#    response_data = json_response(conn, 201)["data"] |> to_atom_keys

#    assert response_data == expected_data
#  end

#  test "try to create a one-to-one chatroom, show chatroom instead", %{conn: conn, consumer: consumer, another_consumer: another_consumer, chatroom: chatroom} do
#    new_consumer = create(:consumer)
 #   %Chatroom{}
#      |> Chatroom.changeset(%{
#            name: "test_chatroom",
#            chat_participations: [
#              %{consumer_id: consumer.id},
#              %{consumer_id: another_consumer.id, },
#              %{consumer_id: new_consumer.id}
#            ]
#          })
#      |> Repo.insert!

#    chat_participation = hd consumer.chat_participations
#    chatroom = %{ chatroom | current_chat_participation: chat_participation}

#    data = %{
#      consumer_id: another_consumer.id
#    }

#    conn = post(conn, api_v1_consumer_chatroom_path(conn, :create), data)

#    assert conn.status == 200
#    chatroom = conn.assigns.chatroom
 #   expected_data = expected_render chatroom
 #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
#    assert response_data == expected_data
#  end

#  test "create a group chatroom", %{conn: conn, consumer: consumer, another_consumer: another_consumer}  do
#    new_conumser = create(:consumer)
#    consumer_ids = [another_consumer.id, new_conumser.id]
#    data = %{
#      name: "test",
#      consumer_ids: consumer_ids
#    }
#    conn = post(conn, api_v1_consumer_chatroom_path(conn, :create), data)

#    assert conn.status == 201
#    chatroom = conn.assigns.new_chatroom

#    expected_data = expected_render chatroom
#    response_data = json_response(conn, 201)["data"] |> to_atom_keys

#    assert response_data == expected_data
#  end

#  test "join a chatroom", %{conn: conn, consumer: consumer, another_consumer: another_consumer}  do
 #   consumer_ids = [consumer.id, another_consumer.id]
#    { :ok, chatroom } = CreateChatroom.call(%{name: "test", consumer_ids: consumer_ids})
#    new_consumer = create(:consumer)
 #   data = %{
 #     new_consumer_id: new_consumer.id
#    }
 #   conn = put(conn, api_v1_consumer_chatroom_path(conn, :update, chatroom), data)

#    assert conn.status == 200
#    chatroom = conn.assigns.updated_chatroom

#    expected_data = expected_render chatroom
#    response_data = json_response(conn, 200)["data"] |> to_atom_keys

#    assert response_data == expected_data
#  end

  defp expected_render(chatroom) do
    chatroom_info = _get_chatroom_info(chatroom)
    {:ok, unread_count } = UnreadCount.call(%{chat_participation: chatroom.current_chat_participation})
    %{
      id: chatroom.id,
      name: chatroom_info.name,
      fb_user_id: chatroom_info.fb_user_id,
      is_group_chat: chatroom.is_group_chat,
      chat_participations: chatroom.chat_participations |> Enum.map(&%{
        id: &1.id,
        chatroom_id: &1.chatroom_id,
        consumer_id: &1.consumer_id,
        last_read_chat_message_id: &1.last_read_chat_message_id,
        consumer: %{
          id: &1.consumer.id,
          name: &1.consumer.name,
          fb_user_id: &1.consumer.fb_user_id,
          about_me: &1.consumer.about_me,
          inserted_at: Ecto.DateTime.to_iso8601(&1.consumer.inserted_at),
          updated_at: Ecto.DateTime.to_iso8601(&1.consumer.inserted_at),
        },
        inserted_at: Ecto.DateTime.to_iso8601(&1.inserted_at),
        updated_at: Ecto.DateTime.to_iso8601(&1.inserted_at),
      }),
      chat_messages: [],
      unread_count: unread_count,
      inserted_at: Ecto.DateTime.to_iso8601(chatroom.inserted_at),
      updated_at: Ecto.DateTime.to_iso8601(chatroom.inserted_at),
    }
  end

  defp _get_chatroom_info(chatroom) do
    if (chatroom.name == nil) do
      current_chat_participation_id = chatroom.current_chat_participation.id
      participations = Enum.reject(chatroom.chat_participations, fn(x) -> x.id == current_chat_participation_id end)
      %{name: hd(participations).consumer.name, fb_user_id: hd(participations).consumer.fb_user_id}
    else
      %{name: chatroom.name, fb_user_id: ""}
    end
  end

  defp _render_name(chatroom) do
    if (chatroom.name == nil) do
      current_chat_participation_id = chatroom.current_chat_participation.id
      participations = Enum.reject(chatroom.chat_participations, fn(x) -> x.id == current_chat_participation_id end)
      hd(participations).consumer.name
    else
      chatroom.name
    end
  end
end
