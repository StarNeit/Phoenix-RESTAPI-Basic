defmodule Playdays.Session do
  use Playdays.Web, :model

  schema "sessions" do
    belongs_to :consumer,  Playdays.Consumer
    belongs_to :time_slot,  Playdays.TimeSlot

    field :status, :string, default: "pending" # pending || joined || rejected
    timestamps
  end

  @required_fields [:consumer_id, :time_slot_id, :status]
  @whitelist_fields @required_fields ++ []

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:consumer_id)
    |> foreign_key_constraint(:time_slot_id)
    |> unique_constraint(:consumer_id_time_slot_id)
  end
end
