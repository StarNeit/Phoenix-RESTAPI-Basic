defmodule Playdays.Consumer.NotificationChannel do
  use Playdays.Web, :channel

  require Logger

  alias Playdays.Endpoint
  alias Playdays.Repo
  alias Playdays.Queries.ConsumerQuery
  alias Playdays.Api.V1.Consumer.FriendRequestView
  alias Playdays.Api.V1.Consumer.ChatroomView
  alias Playdays.Api.V1.Consumer.SessionView
  alias Playdays.Api.V1.Consumer.ReminderView

  import Playdays.Utils.MapUtils

  def join("consumer_notifications:" <> consumer_id, payload, socket) do
    # TODO check fb_user_id device_uuid
    _payload = payload
                |> to_atom_keys
    consumer = ConsumerQuery.find_one(%{
                  id: consumer_id
                })
    if authorized?(%{user: consumer}) do
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

  def new_friend_request_created(friend_request) do
    topic = topic(friend_request.requestee_id)
    event = "friend_request:created"
    data = FriendRequestView.render("show.json", %{friend_request: friend_request})

    Endpoint.broadcast! topic, event, data
  end

  def friend_request_accepted(friend_request) do
    topic = topic(friend_request.requester_id)
    event = "friend_request:accepted"
    data = FriendRequestView.render("show.json", %{friend_request: friend_request})

    Endpoint.broadcast! topic, event, data
  end

  def new_chatroom_created(chatroom) do
    event = "chatroom:created"
    data = ChatroomView.render("show.json", %{ chatroom: chatroom })
    Enum.each(chatroom.chat_participations, fn(participant) ->
      topic = topic(participant.consumer_id)
      Endpoint.broadcast! topic, event, data
    end)
  end

  def new_chat_participation_joined(chatroom, new_consumer_id) do
    event = "chat_participation:new_joined"
    data = ChatroomView.render("show.json", %{ chatroom: chatroom })
    chat_participations = chatroom.chat_participations |> Enum.reject(&(&1.consumer_id == new_consumer_id))
    Enum.each(chatroom.chat_participations, fn(participant) ->
      topic = topic(participant.consumer_id)
      Endpoint.broadcast! topic, event, data
    end)
  end

  def session_approved(session) do
    topic = topic(session.consumer_id)
    event = "session:approved"
    data = SessionView.render("show.json", %{session: session})

    Endpoint.broadcast! topic, event, data
  end

  def session_rejected(session) do
    topic = topic(session.consumer_id)
    event = "session:rejected"
    data = SessionView.render("show.json", %{session: session})

    Endpoint.broadcast! topic, event, data
  end

  def new_reminder_created(reminder) do
    topic = topic(reminder.consumer_id)
    event = "reminder:created"
    data = ReminderView.render("show.json", %{reminder: reminder})
    Endpoint.broadcast! topic, event, data
  end

  defp authorized?(%{user: user}) do
    user != nil
  end

  defp topic(consumer_id) do
    "consumer_notifications:" <> Integer.to_string(consumer_id)
  end
end
