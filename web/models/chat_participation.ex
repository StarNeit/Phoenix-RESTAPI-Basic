defmodule Playdays.ChatParticipation do
  use Playdays.Web, :model

  schema "chat_participations" do
    field :last_read_chat_message_id, :integer

    belongs_to :chatroom, Playdays.Chatroom
    belongs_to :consumer, Playdays.Consumer

    has_many :chat_messages, Playdays.ChatMessage

    timestamps
  end

  @whitelist_fields [:chatroom_id, :consumer_id, :last_read_chat_message_id]
  @required_fields []

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:chat_messages, required: false)
    |> assoc_constraint(:chatroom)
    |> assoc_constraint(:consumer)
    |> unique_constraint(:chatroom_id, name: :index_c_p_on_cr_id_c_id_uni_idx)
  end


  def add_chat_message(model, chat_message) do
    chat_messages = model.chat_messages ++ [chat_message]
    changeset = Enum.map(chat_messages, &Ecto.Changeset.change/1)
    model |> put_chat_messages_assoc(changeset)
  end

  def remove_chat_message(model, chat_message) do
    chat_messages = model.chat_messages |> Enum.reject(&(&1.id == chat_message.id))
    changeset = Enum.map(chat_messages, &Ecto.Changeset.change/1)
    model |> put_chat_messages_assoc(changeset)
  end

  defp put_chat_messages_assoc(model, changeset) do
    model
      |> Ecto.Changeset.change
      |> Ecto.Changeset.put_assoc(:chat_messages, changeset)
  end

end
