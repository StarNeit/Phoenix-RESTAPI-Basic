defmodule Playdays.Services.Consumer.FriendRequest.AcceptFriendRequest do
  require Logger

  alias Playdays.Repo
  alias Playdays.Consumer
  alias Playdays.FriendRequest
  alias Playdays.Queries.FriendRequestQuery
  alias Playdays.Services.Consumer.Reminder.CreateReminder

  def call(%{request: request, requester: requester, requestee: requestee}) do
    case request.requestee_id == requestee.id do
      false ->
        {:error, :permission_denied}
      true ->
        case  request |> FriendRequest.changeset(%{state: "accpeted"}) |> Repo.update do
          {:ok, updated_request} ->
            requester = requester |> Repo.preload(:friends)
            requestee = requestee |> Repo.preload(:friends)
            requester |> Consumer.add_friend(requestee) |> Repo.update!
            requestee |> Consumer.add_friend(requester) |> Repo.update!

            {status, reminder} = CreateReminder.accepted_friend_request_reminder(updated_request)
            if status == :ok, do: {:ok, {updated_request, reminder}}, else: {:error, reminder}
          {:error, changeset} ->
            {:error, changeset}
        end
    end
  end
end
