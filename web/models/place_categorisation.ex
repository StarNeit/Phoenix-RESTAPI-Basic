defmodule Playdays.PlaceCategorisation do
  use Playdays.Web, :model

  schema "place_categorisations" do
    belongs_to :place, Playdays.Place
    belongs_to :category, Playdays.Category

    timestamps
  end

  @whitelist_fields [:place_id, :category_id]
  @required_fields [:place_id, :category_id]

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:place_id, name: :place_categorisations_place_id_category_id_index)
    |> unique_constraint(:category_id, name: :place_categorisations_category_id_place_id_index)
  end
end
