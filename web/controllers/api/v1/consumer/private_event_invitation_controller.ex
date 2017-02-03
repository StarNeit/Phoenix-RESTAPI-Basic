defmodule Playdays.Api.V1.Consumer.PrivateEventInvitationController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.ChangesetView
  alias Playdays.Api.V1.ErrorView
  alias Playdays.PrivateEventInvitation
  alias Playdays.Queries.PrivateEventParticipationQuery
  alias Playdays.Queries.PrivateEventInvitationQuery
  alias Playdays.Services.Consumer.PrivateEvent.JoinPrivateEvent
  alias Playdays.Services.Consumer.PrivateEventInvitation.AcceptPrivateEventInvitation
  alias Playdays.Services.Consumer.Reminder.CreateReminder
  alias Playdays.Consumer.NotificationChannel
  alias Playdays.Services.Consumer.PushNotification.SendPushNotification


  plug :put_private_event_invitation when action in [:update]
  plug :updated_private_event_invitation when action in [:update]

  def update(conn, _params) do
    invitation = conn.assigns.updated_private_event_invitation
    conn
    |> put_status(:ok)
    |> put_resp_header("location", api_v1_consumer_private_event_invitation_path(conn, :update, invitation))
    |> render("show.json", private_event_invitation: invitation)
  end

  defp put_private_event_invitation(conn, _params) do
    id = conn.params["id"]
    query = PrivateEventInvitationQuery.find_one(%{id: id}, preload: [:private_event, :consumer])
    case query do
      nil ->
        conn
          |> put_status(:not_found)
          |> render(ErrorView, "404.json")
      private_event_invitation ->
        conn |> assign(:private_event_invitation, private_event_invitation)
    end
  end

  defp updated_private_event_invitation(%{params: %{"action_type" => "accept"}} = conn, _options) do
    case AcceptPrivateEventInvitation.call(%{private_event_invitation: conn.assigns.private_event_invitation}) do
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
        |> halt
      {:ok, invitation} ->
        current_consumer = conn.assigns.current_consumer
        invitation = invitation |> Repo.preload([private_event: [:consumer, :private_event_participations]])
        private_event = invitation.private_event
        { :ok,  updated_private_event} = JoinPrivateEvent.call(%{private_event: private_event, new_consumer_id: current_consumer.id})

        participation = PrivateEventParticipationQuery.find_one(
                          %{consumer_id: current_consumer.id, private_event_id: updated_private_event.id},
                          preload: [:consumer, private_event: [:consumer]]
                        )

        reminder = CreateReminder.call!(%{type: "newPrivateEventParticipationReminder", private_event_participation: participation}) |> Repo.preload([private_event_participation: [private_event: [:consumer, :place, private_event_participations: [:consumer], private_event_invitations: [:consumer]]]])

        NotificationChannel.new_reminder_created(reminder)

        invitation = PrivateEventInvitationQuery.find_one(
                      %{ id: invitation.id },
                      preload: [:consumer, private_event: [:consumer, :place, private_event_participations: [:consumer], private_event_invitations: [:consumer]]]
                     )
        ## send push notification
        host = invitation.private_event.consumer

        SendPushNotification.call(%{type: "accepted_private_event_invitation", host: host, private_event_invitation: invitation})

        conn |> assign(:updated_private_event_invitation, invitation)
    end
  end
end
