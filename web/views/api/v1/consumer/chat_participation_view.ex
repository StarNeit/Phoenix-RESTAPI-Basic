defmodule Playdays.Api.V1.Consumer.ChatParticipationView do
  use Playdays.Web, :view

  @json_attrs ~W(id chatroom_id consumer_id last_read_chat_message_id inserted_at updated_at)a

  alias Playdays.Api.V1.Consumer.ConsumerView

  def render("index.json", %{chat_participation: chat_participation}) do
    %{ data: render_many(chat_participation, __MODULE__, "chat_participation_details.json")}
  end

  def render("show.json", %{chat_participation: chat_participation}) do
    %{ data: render_one(chat_participation, __MODULE__, "chat_participation_details.json") }
  end

  def render("chat_participation_details.json", %{chat_participation: chat_participation}) do
    chat_participation
      |> _render_details
  end

  def _render_details(chat_participation) do
    chat_participation
      |> Map.take(@json_attrs)
      |> Map.put(:consumer, render_one(chat_participation.consumer, ConsumerView, "consumer_lite.json"))
  end
end
