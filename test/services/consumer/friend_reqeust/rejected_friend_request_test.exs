defmodule Playdays.Services.Consumer.FriendRequest.RejectFriendRequestTest do
  use Playdays.ModelCase, async: false

  alias Playdays.Repo
  alias Playdays.FriendRequest
  alias Playdays.Services.Consumer.FriendRequest.CreateFriendRequest
  alias Playdays.Services.Consumer.FriendRequest.RejectFriendRequest


  setup do
    consumer = create(:consumer)
    another_consumer = create(:consumer)
    {:ok, consumer: consumer, another_consumer: another_consumer}
  end

  test "reject friend request" do
    
  end

end
