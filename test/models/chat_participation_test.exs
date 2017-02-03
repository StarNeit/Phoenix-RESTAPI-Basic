defmodule Playdays.ChatParticipationTest do
  use Playdays.ModelCase, async: true

  alias Playdays.Chatroom
  alias Playdays.ChatParticipation
  alias Playdays.ChatMessage

  @valid_attrs %{
    chatroom_id: 1,
    consumer_id: 1
  }

  @invalid_attrs %{}

  test "changeset with vaild attributes" do
    changeset = %ChatParticipation{} |> ChatParticipation.changeset(@valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = %ChatParticipation{} |> ChatParticipation.changeset(@invalid_attrs)
    assert changeset.valid?
  end

  # test "update chat participation with chat messages" do
  #   consumer = create(:consumer)
  #   another_consumer = create(:consumer)
   #  { :ok, chatroom } = %Chatroom{}
  #                           |> Chatroom.changeset(%{
  #                                 name: "test chat room",
  #                                chat_participations: [
  #                                   %{ consumer_id: consumer.id },
  #                                   %{ consumer_id: another_consumer.id }
   #                                ]
  #                               })
  #                           |> Repo.insert
 #   consumer = consumer |> Repo.preload(:chat_participations)
  #   chat_participation = hd(chatroom.chat_participations) |> Repo.preload(:chat_messages)
  #   message = %ChatMessage{text_content: "testing stuff"}
  #   { state, updated_chat_participation } = chat_participation
   #                                  |> ChatParticipation.add_chat_message(message)
  #                                   |> Repo.update

  #   assert state == :ok

   #  messages_count = length updated_chat_participation.chat_messages
  #   assert messages_count == 1
  # end
end
