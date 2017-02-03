defmodule Playdays.TrialClass do
  use Playdays.Web, :model

  schema "trial_classes" do
    field :name,              :string
    field :website_url,       :string
    field :contact_number,    :string
    field :location_address,  :string
    field :description,       :string
    field :image,             :string
    field :is_active,         :boolean, default: true


    has_many :time_slots,               Playdays.TimeSlot, on_delete: :delete_all

    timestamps
  end

  @required_fields [:name, :website_url, :contact_number, :location_address, :description, :image, :is_active]
  @whitelist_fields @required_fields ++ []

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:time_slots, required: true)
end
end
