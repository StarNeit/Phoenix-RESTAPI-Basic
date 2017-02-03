defmodule Playdays.Admin do
  use Playdays.Web, :model

  schema "admins" do
    field :email,                       :string
    field :name,                        :string
    field :hashed_password,             Playdays.Ecto.Types.HashedField
    field :authentication_token,        :string

    timestamps
  end

  @whitelist_fields [:email, :name, :hashed_password, :authentication_token]
  @required_fields [:email, :hashed_password]

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:email, min: 5)
    |> validate_length(:hashed_password, min: 1)
    |> unique_constraint(:email, name: :admins_email_index)
    |> unique_constraint(:authentication_token, name: :admins_authentication_token_index)
  end
end
