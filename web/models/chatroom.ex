defmodule Playdays.Chatroom do
  use Playdays.Web, :model

  schema "chatrooms" do
    field :name, :string
    field :is_group_chat, :boolean, default: false
    field :current_chat_participation, :map, virtual: true
    has_many :chat_participations, Playdays.ChatParticipation, on_replace: :delete, on_delete: :delete_all
    has_many :chat_messages, through: [:chat_participations, :chat_messages]
    belongs_to :private_event, Playdays.PrivateEvent

    timestamps
  end

  @whitelist_fields [:name, :is_group_chat]
  @required_fields []

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:chat_participations, required: true)
  end

  def add_chat_participation(model, chat_participation) do
    chat_participations = model.chat_participations ++ [chat_participation]
    changeset = Enum.map(chat_participations, &Ecto.Changeset.change/1)
    model |> put_chat_participations_assoc(changeset)
  end

  def remove_chat_participation(model, chat_participation) do
    chat_participations = model.chat_participations |> Enum.reject(&(&1.id == chat_participation.id))
    changeset = Enum.map(chat_participations, &Ecto.Changeset.change/1)
    model |> put_chat_participations_assoc(changeset)
  end

  defp put_chat_participations_assoc(model, changeset) do
    model
      |> Ecto.Changeset.change
      |> Ecto.Changeset.put_assoc(:chat_participations, changeset)
  end
end
