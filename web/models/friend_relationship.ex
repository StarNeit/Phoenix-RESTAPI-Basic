defmodule Playdays.FriendRelationship do
  use Playdays.Web, :model

  schema "friend_relationships" do
    belongs_to :consumer_0, Playdays.Consumer, foreign_key: :consumer_0_id
    belongs_to :consumer_1, Playdays.Consumer, foreign_key: :consumer_1_id

    timestamps
  end

  @whitelist_fields [:consumer_0, :consumer_1]
  @required_fields [:consumer_0, :consumer_1]

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:consumer_0_id, name: :friend_relationships_consumer_0_id_consumer_1_id_index)
    |> unique_constraint(:consumer_1_id, name: :friend_relationships_consumer_1_id_consumer_0_id_index)
  end
end
