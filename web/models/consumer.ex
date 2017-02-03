defmodule Playdays.Consumer do
  use Playdays.Web, :model

  schema "consumers" do
    field :name,          :string
    field :email,         :string
    field :fb_user_id,    :string
    field :about_me,      :string
    field :languages,     {:array, :string}
    field :mobile_phone_number, :string


    belongs_to :region, Playdays.Region
    belongs_to :district, Playdays.District
    embeds_many :children, Playdays.Child, on_replace: :delete
    embeds_many :devices, Playdays.Device, on_replace: :delete
    has_many :reminders, Playdays.Reminder
    many_to_many :friends, Playdays.Consumer, join_through: Playdays.FriendRelationship,
    join_keys: [consumer_0_id: :id, consumer_1_id: :id], on_replace: :delete, on_delete: :delete_all
    has_many :outbound_friend_requests, Playdays.FriendRequest, foreign_key: :requester_id
    has_many :inbound_friend_requests, Playdays.FriendRequest, foreign_key: :requestee_id

    many_to_many :joined_sessions, Playdays.TimeSlot, join_through: Playdays.Session,
    join_keys: [consumer_id: :id, time_slot_id: :id], on_replace: :delete, on_delete: :delete_all

    has_many :chat_participations, Playdays.ChatParticipation, on_delete: :delete_all
    has_many :chatrooms, through: [:chat_participations, :chatroom], on_delete: :delete_all
    has_many :chat_messages, through: [:chat_participations, :chat_messages], on_delete: :delete_all

    has_many :private_events, Playdays.PrivateEvent
    has_many :private_event_invitations, Playdays.PrivateEventInvitation
    has_many :private_event_participations, Playdays.PrivateEventParticipation
    has_many :joined_private_events, through: [:private_event_participations, :private_event], on_delete: :delete_all

    timestamps
  end

  @required_fields [:name, :email, :fb_user_id, :region_id, :district_id]
  @whitelist_fields @required_fields ++ [:mobile_phone_number, :about_me, :languages]


  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
    |> cast_embed(:children, required: false)
    |> cast_embed(:devices, required: true)
    |> cast_assoc(:friends, required: false)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:email, min: 5)
    |> assoc_constraint(:region)
    |> assoc_constraint(:district)
    |> unique_constraint(:email, name: :consumers_email_index)
    |> unique_constraint(:fb_user_id, name: :consumers_fb_user_id_index)
  end

  def find_device(model, %{uuid: uuid}) do
    model.devices |> Enum.find(fn(x) -> x.uuid == uuid end)
  end

  def add_device(model, device) do
    devices = model.devices ++ [device]
    devices_changeset = Enum.map(devices, &Ecto.Changeset.change/1)
    model |> put_devices_embed(devices_changeset)
  end

  def remove_device(model, device) do
    devices = model.devices |> Enum.reject(fn(x) -> x.id == device.id end)
    devices_changeset = Enum.map(devices, &Ecto.Changeset.change/1)
    model |> put_devices_embed(devices_changeset)
  end

  def add_friend(model, friend) do
    friends = model.friends ++ [friend]
    friends_changeset = Enum.map(friends, &Ecto.Changeset.change/1)
    model |> put_friends_assoc(friends_changeset)
  end

  def remove_friend(model, friend) do
    friends = model.friends |> Enum.reject(&(&1.id == friend.id))
    friends_changeset = Enum.map(friends, &Ecto.Changeset.change/1)
    model |> put_friends_assoc(friends_changeset)
  end

  defp put_devices_embed(model, devices_changeset) do
    model
      |> Ecto.Changeset.change
      |> Ecto.Changeset.put_embed(:devices, devices_changeset)
  end

  defp put_friends_assoc(model, friends_changeset) do
    model
      |> Ecto.Changeset.change
      |> Ecto.Changeset.put_assoc(:friends, friends_changeset)
  end

  def search(query, search_term) do
    from(
      u in query,
      where: fragment("? % ?", u.name, ^search_term),
      order_by: fragment("similarity(?, ?) DESC", u.name, ^search_term)
    )
  end
end
