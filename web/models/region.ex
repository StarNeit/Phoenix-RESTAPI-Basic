defmodule Playdays.Region do
  use Playdays.Web, :model

  schema "regions" do
    field :name, :string
    field :hex_color_code, :string
    has_many :districts, Playdays.District

    timestamps
  end

  @whitelist_fields [:name, :hex_color_code]
  @required_fields [:name, :hex_color_code]

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name, name: :region_name_index)
    |> unique_constraint(:hex_color_code, name: :region_hex_color_code_index)
  end

end
