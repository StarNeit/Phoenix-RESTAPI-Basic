defmodule Playdays.Api.V1.Consumer.ChatroomController do
  use Playdays.Web, :controller

  import Playdays.Utils.MapUtils

  alias Playdays.ChangesetView
  alias Playdays.Api.V1.ErrorView
  alias Playdays.Queries.ChatroomQuery
  alias Playdays.Services.Consumer.Chatroom.CreateChatroom
  alias Playdays.Services.Consumer.Chatroom.JoinChatroom
  alias Playdays.Consumer.NotificationChannel

  plug :scrub_params, "new_consumer_id" when action in [:update]

  plug :put_chatroom when action in [:show, :update]
  plug :create_chatroom when action in [:create]
  plug :update_chatroom when action in [:update]

  def index(conn, _params) do
    current_consumer = conn.assigns.current_consumer |> Repo.preload(:chatrooms)
    chatrooms = ChatroomQuery.find_chatrooms_details(current_consumer.chatrooms)

    chatrooms = Enum.map(chatrooms, fn(chatroom) ->
                  current_chat_participation = chatroom.chat_participations |> Enum.find(fn(x) -> x.consumer_id == current_consumer.id end)
                  chatroom = %{ chatroom | current_chat_participation: current_chat_participation }
                  chatroom
                end)

    conn |> render("index.json", chatrooms: chatrooms)
  end

  def show(conn, _params) do
    current_consumer = conn.assigns.current_consumer
    chatroom = conn.assigns.current_chatroom |> Repo.preload([:chat_messages, chat_participations: [:consumer]])
    current_chat_participation = chatroom.chat_participations |> Enum.find(fn(x) -> x.consumer_id == current_consumer.id end)
    chatroom = %{ chatroom | current_chat_participation: current_chat_participation }

    conn
    |> put_status(:ok)
    |> put_req_header("location", api_v1_consumer_chatroom_path(conn, :show, chatroom))
    |> render("show.json", chatroom: chatroom)
  end

  def create(conn, _params) do
    conn
    |> put_status(:created)
    |> put_resp_header("location", api_v1_consumer_chatroom_path(conn, :create))
    |> render("show.json", chatroom: conn.assigns.new_chatroom)
  end

  def update(conn, _params) do
    chatroom = conn.assigns.updated_chatroom
    conn
    |> put_status(:ok)
    |> put_resp_header("location", api_v1_consumer_chatroom_path(conn, :update, chatroom))
    |> render("show.json", chatroom: chatroom)
  end

  defp put_chatroom(conn, _params) do
    id = conn.params["id"]
    query = ChatroomQuery.find_one(%{id: id}, preload: [:chat_messages, chat_participations: [:consumer]])
    case query do
      nil ->
        conn
          |> put_status(:not_found)
          |> render(ErrorView, "404.json")
          |> halt
      chatroom ->
        conn |> assign(:current_chatroom, chatroom)
    end
  end

  defp create_chatroom(%{params: %{"consumer_id" => consumer_id}} = conn, _options) do
    current_consumer = conn.assigns.current_consumer

    case ChatroomQuery.find(%{current_consumer_id: current_consumer.id, consumer_id: consumer_id}) do
      nil ->
        consumer_ids = [current_consumer.id, consumer_id]
        case CreateChatroom.call(%{consumer_ids: consumer_ids}) do
          { :error, changeset } ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(ChangesetView, "error.json", changeset: changeset)
            |> halt
          { :ok, chatroom } ->
            chatroom = chatroom |> Repo.preload([:chat_messages, chat_participations: [:consumer]])
            current_chat_participation = chatroom.chat_participations |> Enum.find(fn(x) -> x.consumer_id == current_consumer.id end)
            chatroom = %{ chatroom | current_chat_participation: current_chat_participation }
            NotificationChannel.new_chatroom_created(chatroom)
            conn
              |> assign(:new_chatroom, chatroom)
        end
      chatroom ->
        chatroom = chatroom |> Repo.preload([:chat_messages, chat_participations: [:consumer]])
        current_chat_participation = chatroom.chat_participations |> Enum.find(fn(x) -> x.consumer_id == current_consumer.id end)
        chatroom = %{ chatroom | current_chat_participation: current_chat_participation }
        NotificationChannel.new_chatroom_created(chatroom)
        conn
        |> put_status(:ok)
        |> assign(:chatroom, chatroom)
        |> render("show.json", chatroom: chatroom)
        |> halt
    end
  end

  defp create_chatroom(conn, _options) do
    current_consumer = conn.assigns.current_consumer
    params = conn.params |> to_atom_keys
    name = params.name
    consumer_ids = params.consumer_ids ++ [current_consumer.id]
    case CreateChatroom.call(%{name: name, consumer_ids: consumer_ids}) do
      { :error, changeset } ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ChangesetView, "error.json", changeset: changeset)
        |> halt
      { :ok, chatroom } ->
        chatroom = chatroom |> Repo.preload([:chat_messages, chat_participations: [:consumer]])

        current_chat_participation = chatroom.chat_participations |> Enum.find(fn(cp) -> cp.consumer_id == current_consumer.id end)
        chatroom = %{ chatroom | current_chat_participation: current_chat_participation }
        NotificationChannel.new_chatroom_created(chatroom)
        conn |> assign(:new_chatroom, chatroom)
    end
  end

  defp update_chatroom(%{params: %{"new_consumer_id" => new_consumer_id}} = conn, _options) do
    current_consumer = conn.assigns.current_consumer
    chatroom = conn.assigns.current_chatroom
    case JoinChatroom.call(%{chatroom: chatroom, new_consumer_id: new_consumer_id}) do
      { :error, changeset } ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ChangesetView, "error.json", changeset: changeset)
        |> halt
      { :ok, updated_chatroom } ->
        updated_chatroom = updated_chatroom |> Repo.preload([:chat_messages, chat_participations: [:consumer]])

        current_chat_participation = updated_chatroom.chat_participations |> Enum.find(fn(x) -> x.consumer_id == current_consumer.id end)
        updated_chatroom = %{ updated_chatroom | current_chat_participation: current_chat_participation }
        NotificationChannel.new_chat_participation_joined(updated_chatroom, new_consumer_id);
        conn |> assign(:updated_chatroom, updated_chatroom)
    end
  end
end
