defmodule Playdays.PrivateEventParticipation do
  use Playdays.Web, :model

  schema "private_event_participations" do
    belongs_to :private_event,    Playdays.PrivateEvent
    belongs_to :consumer, Playdays.Consumer

    timestamps
  end

  @required_fields [:consumer_id]
  @whitelist_fields @required_fields ++ [:private_event_id]

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:private_event)
    |> assoc_constraint(:consumer)
    |> unique_constraint(:consumer_id, name: :private_event_participations_private_event_id_consumer_id_index)
  end
end
