defmodule Playdays.Api.V1.Consumer.ChatMessageControllerTest do
  use Playdays.ConnCase, async: false
  import Playdays.Utils.MapUtils
  import Mock

  alias Playdays.Consumer
  alias Playdays.Chatroom
  alias Playdays.Queries.ChatroomQuery
  alias Playdays.Services.PushNotification.SendPush

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
    chatroom = ChatroomQuery.find_one(%{id: chatroom.id}, preload: [chat_participations: [:consumer], chat_messages: [chat_participation: [:consumer]]])
    conn = conn()
            |> put_req_header("accept", "application/json")
            |> put_req_header("x-fb-user-id", consumer.fb_user_id)
            |> put_req_header("x-device-uuid", device.uuid)
            |> put_req_header("x-fb-access-token", device.fb_access_token)

    {:ok, conn: conn, consumer: consumer, another_consumer: another_consumer, chatroom: chatroom}
  end

#  test "create a chat message", %{conn: conn, chatroom: chatroom, consumer: consumer} do
#    with_mock SendPush, [call: fn(_) -> end] do
#      consumer = consumer |> Repo.preload(:chat_participations)
#      chat_participation = hd(consumer.chat_participations) |> Repo.preload(:consumer)
#      data = %{
#        chatroom_id: chatroom.id,
#        chat_participation_id: chat_participation.id,
#        text_content: "text"
#      }

#      conn = post(conn, api_v1_consumer_chat_message_path(conn, :create), data)
#      assert conn.status == 201

#      chat_message = conn.assigns.new_chat_message
#      expected_data = expected_show_render chat_message

#      response_data = json_response(conn, 201)["data"] |> to_atom_keys
##      assert response_data == expected_data
#      case chatroom.is_group_chat do
##        true -> title = "#{chatroom.name}"
#        false -> title = "New Message"
#      end

#      message = "#{chat_participation.consumer.name}:\n #{data.text_content}"
#      devices =
#      conn.assigns.current_chatroom.chat_participations
#      |> Enum.reject(&(&1.id == chat_participation.id))
#      |> Enum.flat_map(&(&1.consumer.devices))
#      |> Enum.filter(&(&1.device_token != nil))
#      |> Enum.each(fn(device) ->
#        assert called SendPush.call(%{device: device, title: title, message: message, data: %{}})
#      end)
#    end
#  end

  defp expected_show_render(chat_message) do
    %{
      id: chat_message.id,
      text_content: chat_message.text_content,
      chat_participation_id: chat_message.chat_participation_id,
      chat_participation: %{
        id: chat_message.chat_participation.id,
        consumer_id: chat_message.chat_participation.consumer_id,
        chatroom_id: chat_message.chat_participation.chatroom_id,
        last_read_chat_message_id: chat_message.chat_participation.last_read_chat_message_id,
        consumer: %{
          id: chat_message.chat_participation.consumer.id,
          fb_user_id: chat_message.chat_participation.consumer.fb_user_id,
          name: chat_message.chat_participation.consumer.name,
          about_me: chat_message.chat_participation.consumer.about_me,
          inserted_at: Ecto.DateTime.to_iso8601(chat_message.chat_participation.consumer.inserted_at),
          updated_at: Ecto.DateTime.to_iso8601(chat_message.chat_participation.consumer.inserted_at),
        },
        inserted_at: Ecto.DateTime.to_iso8601(chat_message.chat_participation.inserted_at),
        updated_at: Ecto.DateTime.to_iso8601(chat_message.chat_participation.inserted_at),
      },
      inserted_at: Ecto.DateTime.to_iso8601(chat_message.inserted_at),
      updated_at: Ecto.DateTime.to_iso8601(chat_message.inserted_at),
    }
  end
end
