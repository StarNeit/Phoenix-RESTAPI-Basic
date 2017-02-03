defmodule Playdays.Services.Consumer.Chatroom.CreateChatroom do

  alias Playdays.Repo
  alias Playdays.Chatroom

  def call(%{name: name, consumer_ids: consumer_ids}) do
    chat_participations = consumer_ids |> Enum.map(fn(id) -> %{consumer_id: id } end)
    %Chatroom{}
      |> Chatroom.changeset(%{
            name: name,
            chat_participations: chat_participations,
            is_group_chat: true
          })
      |> Repo.insert
  end

  def call(%{consumer_ids: consumer_ids}) do
    chat_participations = consumer_ids |> Enum.map(fn(id) -> %{consumer_id: id } end)
    %Chatroom{}
      |> Chatroom.changeset(%{
            chat_participations: chat_participations,
            is_group_chat: false
          })
      |> Repo.insert
  end
end
