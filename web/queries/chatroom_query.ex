defmodule Playdays.Queries.ChatroomQuery do
  import Ecto.Query

  alias Playdays.Repo
  use Playdays.Query, model: Playdays.Chatroom

  def find(params), do: find(Playdays.Chatroom, params)

  def find(query, %{current_consumer_id: current_consumer_id, consumer_id: consumer_id}) do
    chatrooms = query
    |> join(:left, [c], cp1 in assoc(c, :chat_participations))
    |> join(:left, [c], cp2 in assoc(c, :chat_participations))
    |> where([c, cp1, cp2], cp1.consumer_id == ^current_consumer_id)
    |> where([c, cp1, cp2], cp2.consumer_id == ^consumer_id)
    |> where([c], c.is_group_chat == false)
    |> preload(:chat_participations)
    |> Repo.all

    chatrooms |> Enum.find(fn(c) -> length(c.chat_participations) == 2 end)
  end

  def find_chatrooms_details(chatrooms) do
    chat_participations_query = from cp in Playdays.ChatParticipation, order_by: cp.insert_at

    ids = Enum.map(chatrooms, &(&1.id))

    Playdays.Chatroom
    |> where([cr], cr.id in ^ids)
    |> join(:left, [cr], cp in assoc(cr, :chat_participations))
    |> join(:left, [cr, cp], cm in assoc(cp, :chat_messages))
    |> join(:left, [cr, cp], c in assoc(cp, :consumer))
    |> preload([cr, cp, cm, c], [chat_messages: cm, chat_participations: {cp, [consumer: c]} ])
    |> Repo.all
  end

end
