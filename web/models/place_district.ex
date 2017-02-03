defmodule Playdays.PlaceDistrict do
  use Playdays.Web, :model

  schema "place_districts" do
    belongs_to :place, Playdays.Place
    belongs_to :district, Playdays.District

    timestamps
  end

  @whitelist_fields [:place_id, :district_id]
  @required_fields [:place_id, :district_id]

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:place_id, name: :place_districts_place_id_district_id_index)
    |> unique_constraint(:district_id, name: :place_districts_district_id_place_id_index)
  end
end
