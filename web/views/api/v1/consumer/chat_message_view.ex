defmodule Playdays.Api.V1.Consumer.ChatMessageView do
  use Playdays.Web, :view

  @json_attrs ~W(id text_content chat_participation_id inserted_at updated_at)a

  alias Playdays.Api.V1.Consumer.ChatParticipationView

  def render("index.json", %{chat_message: chat_message}) do
    %{ data: render_many(chat_message, __MODULE__, "chat_message_details.json")}
  end

  def render("show.json", %{chat_message: chat_message}) do
    %{ data: render_one(chat_message, __MODULE__, "chat_message_details.json") }
  end

  def render("chat_message_lite.json", %{chat_message: chat_message}) do
    chat_message
      |> _render_lite
  end

  def render("chat_message_details.json", %{chat_message: chat_message}) do
    chat_message
      |> _render_details
  end

  defp _render_lite(chat_message) do
    chat_message
      |> Map.take(@json_attrs)
  end

  defp _render_details(chat_message) do
    chat_message
      |> _render_lite
      |> Map.put(:chat_participation, render_one(chat_message.chat_participation, ChatParticipationView, "chat_participation_details.json"))
  end
end
