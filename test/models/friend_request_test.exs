defmodule Playdays.FriendRequestTest do
  use Playdays.ModelCase

  alias Playdays.FriendRequest


  @valid_friend_request_attrs %{
    requester_id: 1,
    requestee_id: 2,
    state: "pending"
  }

  @invalid_friend_request_attrs %{
    requester_id: 1,
    state: "pending"
  }

  test "changeset with valid attributes" do
    changeset = %FriendRequest{} |> FriendRequest.changeset( @valid_friend_request_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = %FriendRequest{} |> FriendRequest.changeset(@invalid_friend_request_attrs)
    refute changeset.valid?
  end

  #test "insert friend request" do
  #  consumer = create(:consumer)
  #  another_consumer = create(:consumer)
  #  request = %FriendRequest{}
  #    |> FriendRequest.changeset(%{
  #        requester_id: consumer.id,
  #        requestee_id: another_consumer.id,
  #        state: "pending",
  #    })
  #    |> Repo.insert!
  #    |> Repo.preload([:requester, :requestee])
  #
  #
  # assert request.requester
  #  assert request.requestee
  #end
end
