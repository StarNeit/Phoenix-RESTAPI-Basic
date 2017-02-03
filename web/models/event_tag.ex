defmodule Playdays.EventTag do
  use Playdays.Web, :model

  schema "event_tags" do
    field :title, :string

    many_to_many :events, Playdays.Event, join_through: Playdays.EventTagging, on_replace: :delete, on_delete: :delete_all
    timestamps
  end

  @whitelist_fields [:title]
  @required_fields [:title]

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:events, required: false)
    # |> cast_assoc(:places, required: false, with: &gen_places_changeset/2)
    |> unique_constraint(:title, name: :event_tags_title_index)
  end

end
