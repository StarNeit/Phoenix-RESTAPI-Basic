defmodule Playdays.Services.Consumer.FriendRequest.CreateFriendRequest do
  require Logger

  alias Playdays.Repo
  alias Playdays.FriendRequest
  alias Playdays.Queries.FriendRequestQuery
  alias Playdays.Services.Consumer.Reminder.CreateReminder

  def call(%{requester: requester, requestee: requestee}) do
    changeset = %FriendRequest{}
      |> FriendRequest.changeset(%{
          requester_id: requester.id,
          requestee_id: requestee.id
        })

    existing_friend_requests = FriendRequestQuery.find_many(%{requester_id: requester.id, requestee_id: requestee.id})
    existing_friend_requests_count = length existing_friend_requests
    case existing_friend_requests_count  do
      0 ->
        insert_and_create_reminder(changeset)
      _ ->
        accepted_friend_requests_count =
          existing_friend_requests
          |> Enum.filter(&(&1.state == "accepted"))
          |> length
        pending_friend_requests_count =
          existing_friend_requests
          |> Enum.filter(&(&1.state == "pending"))
          |> length
        if accepted_friend_requests_count > 0 do
          changeset = Ecto.Changeset.add_error(changeset, :state, "already_accepted")
        else
          if pending_friend_requests_count > 0 do
            changeset = Ecto.Changeset.add_error(changeset, :state, "duplicated")
          end
        end
        insert_and_create_reminder(changeset)
    end
  end

  defp insert_and_create_reminder(changeset) do
    with(
      {:ok, friend_requests} <- changeset |> Repo.insert,
      {:ok, reminder} <- CreateReminder.friend_request_reminder(friend_requests),
      do: {:ok, {friend_requests, reminder}}
    )
  end

end
