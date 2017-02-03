defmodule Playdays.Place do
  use Playdays.Web, :model

  schema "places" do
    field :name,              :string
    field :website_url,       :string
    field :contact_number,    :string
    field :location_address,  :string
    field :description,       :string
    field :image,             :string
    field :is_active,         :boolean, default: true
    field :is_featured,       :boolean, default: false
    field :lat,               :string
    field :long,              :string

    has_many :private_events, Playdays.PrivateEvent

    many_to_many :categories, Playdays.Category, join_through: Playdays.PlaceCategorisation, on_replace: :delete, on_delete: :delete_all
    many_to_many :tags, Playdays.Tag, join_through: Playdays.Tagging, on_replace: :delete, on_delete: :delete_all
    many_to_many :districts, Playdays.District, join_through: Playdays.PlaceDistrict, on_replace: :delete, on_delete: :delete_all

    timestamps
  end

  @required_fields  [:name, :website_url, :contact_number, :location_address, :description, :image, :is_active, :lat, :long, :is_featured]
  @whitelist_fields @required_fields ++ []


  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:categories, required: false)
    |> cast_assoc(:tags, required: false)
    |> cast_assoc(:districts, required: false)
    |> unique_constraint(:name, name: :companies_name_index)
  end
end
