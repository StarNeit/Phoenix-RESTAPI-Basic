defmodule Playdays.ChatMessage do
  use Playdays.Web, :model

  schema "chat_messages" do
    field :text_content, :string

    belongs_to :chat_participation, Playdays.ChatParticipation

    timestamps
  end

  @whitelist_fields [:text_content, :chat_participation_id]
  @required_fields [:text_content]

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:chat_participation_id)
  end

end
