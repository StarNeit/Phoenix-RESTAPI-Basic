defmodule Playdays.Queries.CommentQuery do
  import Ecto.Query

  use Playdays.Query, model: Playdays.Comment


  def find_all_comments(_params) do
    cond do
      !is_nil _params[:event_id] ->
        find_many(%{event_id: _params[:event_id]}, preload: [:member])
      !is_nil _params[:trial_class_id] ->
        find_many(%{trial_class_id: _params[:trial_class_id]}, preload: [:member])
      !is_nil _params[:place_id] ->
        find_many(%{place_id: _params[:place_id]}, preload: [:member])
      true -> []
    end
  end

  # def find_all_comments(%{event_id: event_id}) when !is_nil(event_id) do
  #   CommentQuery.find_many(%{event_id: :event_id}, preload: [:consumer])
  # end
  #
  # def find_all_comments(_) do
  #   # CommentQuery.find_many(%{event_id: :event_id}, preload: [:consumer])
  # end

  # def by_id(id) do
  #   find_one(
  #     %{id: id},
  #     preload: [
  #       :consumer,
  #       friend_request: [:requester, :requestee],
  #       session: [:consumer, time_slot: [:event, :trial_class]],
  #       private_event_invitation: [private_event: [:place, :consumer, private_event_invitations: [:member], private_event_participations: [:member]]],
  #       private_event_participation: [private_event: [:place, :consumer, private_event_invitations: [:consumer], private_event_participations: [:consumer]]],
  #     ]
  #   )
  # end

end
