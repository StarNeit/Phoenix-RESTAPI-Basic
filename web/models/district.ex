defmodule Playdays.District do
  use Playdays.Web, :model

  schema "districts" do
    field :name, :string
    field :hex_color_code, :string

    belongs_to :region, Playdays.Region

    timestamps
  end

  @whitelist_fields [:name, :region_id, :hex_color_code]
  @required_fields [:name, :region_id, :hex_color_code]

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:region)
    |> unique_constraint(:name, name: :districts_name_index)
    |> unique_constraint(:hex_color_code, name: :districts_hex_color_code_index)
  end

end
