defmodule Playdays.Reminder do
  use Playdays.Web, :model

  schema "reminders" do
    belongs_to :consumer,  Playdays.Consumer

    belongs_to :session,  Playdays.Session
    belongs_to :friend_request,  Playdays.FriendRequest

    belongs_to :private_event_invitation, Playdays.PrivateEventInvitation
    belongs_to :private_event_participation, Playdays.PrivateEventParticipation

    field :reminder_type, :string
    # friendRequestReminder | acceptedFriendRequestReminder |
    # joinedPublicEventReminder | sharedPublicEventReminder |
    # joinedTrialClassReminder | rejectedTrialClassReminder |
    # privateEventInvitationReminder
    # newPrivateEventParticipationReminder

    field :state, :string, default: "unread"
    # unread > read > archived
    timestamps
  end

  @required_fields [:state, :reminder_type, :consumer_id]
  @whitelist_fields @required_fields ++ [:session_id, :friend_request_id, :private_event_invitation_id, :private_event_participation_id]

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @whitelist_fields)
    |> validate_required(@required_fields)
  end
end
