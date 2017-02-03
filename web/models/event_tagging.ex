defmodule Playdays.EventTagging do
  use Playdays.Web, :model

  schema "event_taggings" do
    belongs_to :event, Playdays.Event
    belongs_to :event_tag, Playdays.EventTag

    timestamps
  end

  @whitelist_fields [:event_id, :event_tag_id]
  @required_fields [:event_id, :event_tag_id]

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:event_id, name: :event_taggings_event_id_event_tag_id_index)
    |> unique_constraint(:event_tag_id, name: :event_taggings_event_tag_id_event_id_index)
  end
end
