defmodule Playdays.Services.Consumer.ChatMessage.CreateChatMessage do

  alias Playdays.Repo
  alias Playdays.ChatMessage

  def call(%{chat_participation: chat_participation, text_content: text_content}) do
    %ChatMessage{}
      |> ChatMessage.changeset(%{
            chat_participation_id: chat_participation.id,
            text_content: text_content,
          })
      |> Repo.insert
  end
end
