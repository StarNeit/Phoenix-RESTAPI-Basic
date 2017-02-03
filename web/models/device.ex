defmodule Playdays.Device do
  use Playdays.Web, :model

  embedded_schema do
    field :uuid,             :string
    field :fb_access_token,  :string
    field :device_token, :string
    field :platform, :string
    timestamps
  end

  @whitelist_fields [:uuid, :fb_access_token, :device_token, :platform]
  @required_fields [:uuid, :fb_access_token]

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
  end

end
