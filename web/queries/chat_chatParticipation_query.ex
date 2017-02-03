defmodule Playdays.Queries.ChatParticipationQuery do
  import Ecto.Query

  alias Playdays.Repo
  use Playdays.Query, model: Playdays.ChatParticipation

  def unread_count(params), do: unread_count(Playdays.ChatParticipation, params)

  def unread_count(query, %{
      chatroom_id: chatroom_id,
      after_chat_message_id: after_chat_message_id,
      exclude_chat_participation_id: exclude_chat_participation_id
    }) do
    q = query
    |> join(:left, [cp], cm in assoc(cp, :chat_messages))
    |> where([cp, cm], cp.chatroom_id == ^chatroom_id)
    |> where([cp, cm], cp.id != ^exclude_chat_participation_id)
    |> where([cp, cm], cm.id > ^after_chat_message_id)
    |> select([cp, cm], count(cm.id))
    |> Repo.one
  end

  def unread_count(query, %{
      chatroom_id: chatroom_id,
      exclude_chat_participation_id: exclude_chat_participation_id
    }) do
    q = query
    |> join(:left, [cp], cm in assoc(cp, :chat_messages))
    |> where([cp, cm], cp.chatroom_id == ^chatroom_id)
    |> where([cp, cm], cp.id != ^exclude_chat_participation_id)
    |> select([cp, cm], count(cm.id))
    |> Repo.one
  end

end
