defmodule Playdays.Login do
  use Playdays.Web, :model

  schema "logins" do
    field :token, :string
    belongs_to :member, Playdays.Member

    timestamps
  end

  @required_fields ~w(member_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
  def registration_changeset(model, params \\ :empty) do
    model
    |> changeset(params)
    |> put_change(:token, SecureRandom.urlsafe_base64())
  end
end
