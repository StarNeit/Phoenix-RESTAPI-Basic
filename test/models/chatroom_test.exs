defmodule Playdays.ChatroomTest do
  use Playdays.ModelCase

  alias Playdays.Chatroom
  alias Playdays.ChatParticipation

  @valid_attrs %{
    name: "chat room 1",
    chat_participations: [
      %{
        consumer_id: 1
      }
    ]
  }
  @invalid_attrs %{
    name: "chat room 1",
  }

  setup do
    consumer = create(:consumer)
    another_consumer = create(:consumer)

    {:ok, consumer: consumer, another_consumer: another_consumer}
  end

  test "changeset with valid attributes" do
    changeset = Chatroom.changeset(%Chatroom{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Chatroom.changeset(%Chatroom{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "insert chat room with chat_participations should raise InvalidChangesetError " do
    assert_raise Ecto.InvalidChangesetError, fn ->
      %Chatroom{}
      |> Chatroom.changeset(%{name: "test chat room"})
      |> Repo.insert!
    end
  end

#   test "inset chat room with chat_participations", %{ consumer: consumer, another_consumer: another_consumer } do
 #    { state, chatroom } = %Chatroom{}
  #                           |> Chatroom.changeset(%{
   #                                name: "test chat room",
   #                                chat_participations: [
  #                                   %{ consumer_id: consumer.id },
   #                                  %{ consumer_id: another_consumer.id }
   #                                ]
  #                               })
  #                           |> Repo.insert
   #  assert state == :ok
   #  assert chatroom.id
   #  participations_count = length chatroom.chat_participations
  #   assert participations_count == 2
  # end

#   test "add new chat participation to chat room", %{ consumer: consumer, another_consumer: another_consumer} do
#     { :ok, chatroom } = %Chatroom{}
#                             |> Chatroom.changeset(%{
#                                   name: "test chat room",
#                                   chat_participations: [
#                                     %{ consumer_id: consumer.id },
#                                     %{ consumer_id: another_consumer.id }
#                                   ]
#                                 })
#                             |> Repo.insert
#     new_consumer = create(:consumer)
#     chat_participation = %ChatParticipation{consumer_id: new_consumer.id}

#     { state, updated_chatroom } = chatroom
#                                     |> Chatroom.add_chat_participation(chat_participation)
#                                     |> Repo.update

#     assert state == :ok
#     participations_count = length updated_chatroom.chat_participations
#     assert participations_count == 3
#   end

#   test "remove chat participation to chat room", %{ consumer: consumer, another_consumer: another_consumer} do
#     new_consumer = create(:consumer)
#     chatroom  = %Chatroom{}
#                   |> Chatroom.changeset(%{
#                         name: "test chat room",
 #                        chat_participations: [
 #                          %{ consumer_id: consumer.id },
#                           %{ consumer_id: another_consumer.id },
#                           %{ consumer_id: new_consumer.id }
#                         ]
#                       })
#                   |> Repo.insert!

#     chat_participation = hd chatroom.chat_participations
#     { state, updated_chatroom } = chatroom
#                                     |> Chatroom.remove_chat_participation(chat_participation)
#                                     |> Repo.update
#     assert state == :ok
#     participations_count = length updated_chatroom.chat_participations
#     assert participations_count == 2
#   end


end
