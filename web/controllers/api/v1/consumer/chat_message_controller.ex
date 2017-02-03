defmodule Playdays.Api.V1.Consumer.ChatMessageController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.Api.V1.ErrorView

  alias Playdays.Chatroom
  alias Playdays.Queries.ChatroomQuery
  alias Playdays.Queries.ChatParticipationQuery
  alias Playdays.Services.Consumer.ChatMessage.CreateChatMessage
  alias Playdays.Consumer.ChatroomChannel
  alias Playdays.Services.Consumer.PushNotification.SendPushNotification

  plug :authorize_chatroom
  plug :put_chatroom
  plug :scrub_params, "text_content" when action in [:create]
  plug :create_chat_message when action in [:create]

  def create(conn, _params) do
    conn
    |> put_status(:created)
    |> render("show.json", chat_message: conn.assigns.new_chat_message)
  end

  defp authorize_chatroom(conn, _options) do
    case ChatParticipationQuery.find_one(%{chatroom_id: conn.params["chatroom_id"], consumer_id: conn.assigns.current_consumer.id}) do
      nil ->
        conn
        |> put_status(:forbidden)
        |> assign(:errors, %{message: "Forbidden room"})
        |> render(Playdays.ErrorView, "403.json")
        |> halt
      chat_participation ->
        conn |> assign(:chat_participation, chat_participation)
    end
  end

  defp put_chatroom(conn, _options) do
    case ChatroomQuery.find_one(%{id: conn.params["chatroom_id"]}) do
      nil ->
        conn
        |> put_status(:unprocessable_entity)
        |> assign(:errors, %{message: "chat room not found"})
        |> render(Playdays.ErrorView, "422.json")
        |> halt
      chatroom ->
        chatroom = chatroom |> Repo.preload([chat_participations: [:consumer]])
        conn |> assign(:current_chatroom, chatroom)
    end
  end

  defp create_chat_message(conn, _options) do
    chat_participation = conn.assigns.chat_participation |> Repo.preload(:consumer)
    text_content = conn.params["text_content"]
    case CreateChatMessage.call(%{chat_participation: chat_participation, text_content: text_content}) do
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> assign(:errors, changeset)
        |> render(Playdays.ErrorView, "422.json")
        |> halt
      {:ok, chat_message} ->
        chat_message = chat_message |> Repo.preload([chat_participation: [:consumer]])
        ChatroomChannel.new_message_created(chat_message)

        # send push notification
        chatroom = conn.assigns.current_chatroom
        SendPushNotification.call(%{type: "new_chat_message", chatroom: chatroom, chat_participation: chat_participation, text_content: text_content})
        conn |> assign(:new_chat_message, chat_message)
    end
  end
end
