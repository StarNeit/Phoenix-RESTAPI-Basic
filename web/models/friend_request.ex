defmodule Playdays.FriendRequest do
  use Playdays.Web, :model

  schema "friend_requests" do
    field :state, :string, default: "pending"

    belongs_to :requester, Playdays.Consumer
    belongs_to :requestee, Playdays.Consumer
    timestamps
  end

  @whitelist_fields [:requester_id, :requestee_id, :state]
  @required_fields [:requester_id, :requestee_id, :state]

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:requester)
    |> assoc_constraint(:requestee)
  end
end
