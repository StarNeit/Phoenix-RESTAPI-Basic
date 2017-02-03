defmodule Playdays.Queries.ReminderQuery do
  import Ecto.Query

  use Playdays.Query, model: Playdays.Reminder

  def where_consumer_id_is(consumer_id) do
    find_many(
      %{consumer_id: consumer_id},
      preload: [
        :consumer,
        friend_request: [:requester, :requestee],
        session: [:consumer, time_slot: [:event, :trial_class]],
        private_event_invitation: [private_event: [:place, :consumer, private_event_invitations: [:consumer], private_event_participations: [:consumer]]],
        private_event_participation: [private_event: [:place, :consumer, private_event_invitations: [:consumer], private_event_participations: [:consumer]]],
      ]
    )
  end

  def by_id(id) do
    find_one(
      %{id: id},
      preload: [
        :consumer,
        friend_request: [:requester, :requestee],
        session: [:consumer, time_slot: [:event, :trial_class]],
        private_event_invitation: [private_event: [:place, :consumer, private_event_invitations: [:consumer], private_event_participations: [:consumer]]],
        private_event_participation: [private_event: [:place, :consumer, private_event_invitations: [:consumer], private_event_participations: [:consumer]]],
      ]
    )
  end

end
