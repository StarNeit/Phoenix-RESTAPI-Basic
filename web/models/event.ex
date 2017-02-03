defmodule Playdays.Event do
  use Playdays.Web, :model

  defmodule PriceRange do
    use Playdays.Web, :model
    embedded_schema do
      field :hi, :integer
      field :lo, :integer

      timestamps
    end
    @required_fields [:hi, :lo]
    def changeset(model, params \\ :empty) do
      model
      |> cast(params, @required_fields)
      |> validate_required(@required_fields)
    end
  end


  schema "events" do
    field :name,                        :string
    field :website_url,                 :string
    field :location_address,            :string
    field :description,                 :string
    field :contact_number,              :string
    field :image,                       :string
    field :is_active,                   :boolean, default: true
    field :lat,                         :string
    field :long,                        :string
    field :joined_consumer_number,      :integer
    field :number_of_likes,             :integer
    field :booking_url,                 :string
    field :booking_hotline,             :string
    field :booking_email,               :string
    field :is_featured,                 :boolean, default: false


    embeds_one :price_range,            PriceRange, on_replace: :delete
    has_many :time_slots,               Playdays.TimeSlot, on_delete: :delete_all, on_replace: :nilify
    many_to_many :event_tags, Playdays.EventTag, join_through: Playdays.EventTagging, on_replace: :delete, on_delete: :delete_all

    timestamps
  end

  @required_fields [:name, :location_address, :lat, :long, :is_featured]
  @whitelist_fields @required_fields ++ [:website_url, :description, :contact_number, :image, :is_active, :joined_consumer_number, :booking_hotline, :booking_url, :number_of_likes, :booking_email]

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
    |> cast_embed(:price_range, required: true)
    |> cast_assoc(:time_slots, required: true)
    |> cast_assoc(:event_tags, required: false)
    |> unique_constraint(:time_slots_pkey)
  end

  def update_joined_consumer_number(event, offset) do
    event
    |> Playdays.Repo.preload([:time_slots, :event_tags])
    |> changeset(%{joined_consumer_number: event.joined_consumer_number + offset})
    |> Playdays.Repo.update!
  end

end
