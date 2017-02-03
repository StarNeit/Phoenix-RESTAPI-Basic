defmodule Playdays.Member do
  use Playdays.Web, :model
  import Joken

  schema "members" do
    field :fname, :string
    field :lname, :string
    field :email, :string
    field :password_hash, :string
    field :about_me, :string
    field :languages, {:array, :string}
    field :mobile_phone_number, :string
    field :children, {:array, :string}
    field :like_places, {:array, :integer}
    field :like_events, {:array, :integer}
    field :password, :string, virtual: true

    belongs_to :region, Playdays.Region
    belongs_to :district, Playdays.District
    embeds_many :devices, Playdays.Device, on_replace: :delete

    timestamps
  end

  @required_fields ~w(fname lname email password)
  @optional_fields ~w(about_me languages region_id district_id mobile_phone_number children like_events like_places)
  #languages children
  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:email)
    |> validate_length(:password, min: 5)
    |> hash_password
  end

  defp hash_password(changeset) do  
    if password = get_change(changeset, :password) do
      changeset
      #|> put_change(:password_hash, Comeonin.Bcrypt.hashpwsalt(password))
      |> put_change(:password_hash, password)
    else
      changeset
    end
  end

  def generate_token(member) do  
    %{member_id: member.id}
    |> token
    |> with_signer(hs256("secret-change-me"))
    |> sign
    |> get_compact
  end 
end
