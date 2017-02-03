defmodule Playdays.Api.V1.Consumer.ChatroomView do
  use Playdays.Web, :view

  alias Playdays.Services.Consumer.ChatParticipation.UnreadCount
  alias Playdays.Api.V1.Consumer.ChatParticipationView
  alias Playdays.Api.V1.Consumer.ChatMessageView

  @json_attrs ~W(id is_group_chat inserted_at updated_at)a

  def render("index.json", %{chatrooms: chatrooms}) do
    %{ data: render_many(chatrooms, __MODULE__, "chatroom_details.json")}
  end

  def render("show.json", %{chatroom: chatroom}) do
    %{ data: render_one(chatroom, __MODULE__, "chatroom_details.json") }
  end

  def render("chatroom_details.json", %{chatroom: chatroom}) do
    chatroom
      |> _render_details
  end

  def _render_details(chatroom) do
    chatroom_info = _get_chatroom_info(chatroom)
    chatroom
      |> Map.take(@json_attrs)
      |> Map.put(:chat_participations, render_many(chatroom.chat_participations, ChatParticipationView, "chat_participation_details.json"))
      |> Map.put(:chat_messages, render_many(chatroom.chat_messages, ChatMessageView, "chat_message_lite.json"))
      |> Map.put(:unread_count, chatroom |> _render_unread_count)
      |> Map.put(:name, chatroom_info.name)
      |> Map.put(:fb_user_id, chatroom_info.fb_user_id)
  end

  defp _render_unread_count(chatroom) do
    participation = chatroom.current_chat_participation
    {:ok, unread_count} = UnreadCount.call(%{chat_participation: participation})
    unread_count
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
end
