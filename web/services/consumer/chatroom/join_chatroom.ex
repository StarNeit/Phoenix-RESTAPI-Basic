defmodule Playdays.Services.Consumer.Chatroom.JoinChatroom do

  alias Playdays.Repo
  alias Playdays.Chatroom
  alias Playdays.ChatParticipation

  def call(%{chatroom: chatroom, new_consumer_id: new_consumer_id}) do
    new_participation = %ChatParticipation{consumer_id: new_consumer_id}
    chatroom
      |> Chatroom.add_chat_participation(new_participation)
      |> Repo.update
  end
end
