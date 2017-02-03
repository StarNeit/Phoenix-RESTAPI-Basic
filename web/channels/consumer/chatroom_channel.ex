defmodule Playdays.Consumer.ChatroomChannel do
  use Playdays.Web, :channel

  require Logger

  alias Playdays.Endpoint
  alias Playdays.Repo
  alias Playdays.Queries.ChatParticipationQuery
  alias Playdays.Api.V1.Consumer.FriendRequestView
  alias Playdays.Api.V1.Consumer.ChatroomView
  alias Playdays.Api.V1.Consumer.ChatMessageView

  import Playdays.Utils.MapUtils

  def join("consumer_chatrooms:" <> chatroom_id, payload, socket) do
    # TODO check fb_user_id device_uuid
    payload = payload
              |> to_atom_keys

    consumer_id = payload.consumer_id
    chat_participation = ChatParticipationQuery.find_one(%{
                  chatroom_id: chatroom_id,
                  consumer_id: consumer_id,
                })
    if authorized?(%{chat_participation: chat_participation}) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def terminate(message, _socket) do
    case message do
      {:shutdown, :closed} ->
        Logger.info("closed")
      {:shutdown, :left} ->
        Logger.info("left")
    end
  end

  def new_message_created(chat_message) do
    chatroom_id = chat_message.chat_participation.chatroom_id
    topic = topic(%{chatroom_id: chatroom_id})
    event = "chatroom:new_message_created"
    data = ChatMessageView.render("show.json", %{chat_message: chat_message})
    Endpoint.broadcast! topic, event, data
  end


  defp authorized?(%{chat_participation: chat_participation}) do
    chat_participation != nil
  end

  defp topic(%{chatroom_id: chatroom_id}) do
    "consumer_chatrooms:#{Integer.to_string(chatroom_id)}"
  end
end
