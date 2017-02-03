defmodule Playdays.Child do
  use Playdays.Web, :model

  embedded_schema do
    field :birthday, :string
    timestamps
  end

  @whitelist_fields [:birthday]
  @required_fields [:birthday]

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
  end

end
