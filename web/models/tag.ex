defmodule Playdays.Tag do
  use Playdays.Web, :model

  schema "tags" do
    field :title, :string

    many_to_many :places, Playdays.Place, join_through: Playdays.Tagging, on_replace: :delete, on_delete: :delete_all
    timestamps
  end

  @whitelist_fields [:title]
  @required_fields [:title]

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:places, required: false)
    |> unique_constraint(:title, name: :tags_title_index)
  end

end
