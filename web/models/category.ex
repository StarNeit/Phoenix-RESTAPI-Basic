defmodule Playdays.Category do
  use Playdays.Web, :model

  schema "categories" do
    field :title, :string
    field :hex_color_code, :string
    field :image, :string
    many_to_many :places, Playdays.Place, join_through: Playdays.PlaceCategorisation, on_replace: :delete, on_delete: :delete_all
    timestamps
  end

  @whitelist_fields [:title, :hex_color_code, :image]
  @required_fields [:title, :hex_color_code, :image]

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:places, required: false)
    |> unique_constraint(:title, name: :categories_title_index)
    |> unique_constraint(:hex_color_code, name: :categories_hex_color_code_index)
  end

end
