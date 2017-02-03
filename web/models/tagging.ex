defmodule Playdays.Tagging do
  use Playdays.Web, :model

  schema "taggings" do
    belongs_to :place, Playdays.Place
    belongs_to :tag, Playdays.Tag

    timestamps
  end

  @whitelist_fields [:place_id, :tag_id]
  @required_fields [:place_id, :tag_id]

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:place_id, name: :taggings_place_id_tag_id_index)
    |> unique_constraint(:tag_id, name: :taggings_tag_id_place_id_index)
  end
end
