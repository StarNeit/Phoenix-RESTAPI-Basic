defmodule Playdays.Services.Consumer.ChatParticipation.UnreadCount do

  alias Playdays.Queries.ChatParticipationQuery

  def call(%{chat_participation: %{last_read_chat_message_id: last_read_chat_message_id} = chat_participation}) when is_integer(last_read_chat_message_id) do
    unread_count = ChatParticipationQuery.unread_count(%{
                      chatroom_id: chat_participation.chatroom_id,
                      after_chat_message_id: last_read_chat_message_id,
                      exclude_chat_participation_id: chat_participation.id
                    })
    {:ok, unread_count }
  end

  def call(%{chat_participation: chat_participation}) do
    unread_count = ChatParticipationQuery.unread_count(%{
                      chatroom_id: chat_participation.chatroom_id,
                      exclude_chat_participation_id: chat_participation.id
                    })
    {:ok, unread_count }
  end
end
