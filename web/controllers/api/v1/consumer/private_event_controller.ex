defmodule Playdays.Api.V1.Consumer.PrivateEventController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.ChangesetView
  alias Playdays.Api.V1.ErrorView
  alias Playdays.Queries.PrivateEventQuery
  alias Playdays.Services.Consumer.PrivateEvent.CreatePrivateEvent
  alias Playdays.Services.Consumer.Reminder.CreateReminder
  alias Playdays.Consumer.NotificationChannel
  alias Playdays.Services.Consumer.PushNotification.SendPushNotification

  plug :put_private_event when action in [:show, :update]
  plug :create_private_event when action in [:create]

  def index(conn, _params) do
    current_consumer = conn.assigns.current_consumer |> Repo.preload([:private_events, :joined_private_events])

    private_events = current_consumer.private_events |> Repo.preload([:place, :consumer, [private_event_invitations: :consumer], [private_event_participations: :consumer]])
    joined_private_events = current_consumer.joined_private_events |> Repo.preload([:place, :consumer, [private_event_invitations: :consumer], [private_event_participations: :consumer]])
    all_private_events = private_events ++ joined_private_events

    conn |> render("index.json", private_events: all_private_events)
  end

  def create(conn, _params) do
    private_event = conn.assigns.new_private_event
    conn
    |> put_status(:created)
    |> put_resp_header("location", api_v1_consumer_private_event_path(conn, :create))
    |> render("show.json", private_event: private_event)
  end

  def show(conn, _params) do
    render(conn, "show.json", private_event: conn.assigns.private_event)
  end

  def update(conn, _params) do
    private_event = conn.assigns.updated_private_event
    conn
    |> put_status(:ok)
    |> put_resp_header("location", api_v1_consumer_private_event_path(conn, :update, private_event))
    |> render("show.json", private_event: private_event)
  end

  defp put_private_event(conn, _params) do
    id = conn.params["id"]
    query = PrivateEventQuery.find_one(%{id: id}, preload: [:consumer, :place, private_event_invitations: [:consumer], private_event_participations: [:consumer]])
    case query do
      nil ->
        conn
          |> put_status(:not_found)
          |> render(ErrorView, "404.json")
      private_event ->
        conn |> assign(:private_event, private_event)
    end
  end

  defp create_private_event(%{params: %{"invited_consumer_ids" => invited_consumer_ids}} = conn, _options) do
    current_consumer = conn.assigns.current_consumer
    params = conn.params |> to_atom_keys
    case CreatePrivateEvent.call(%{name: params.name, date: params.date, from: params.from, place_id: params.place_id,  consumer_id: current_consumer.id, invited_consumer_ids: invited_consumer_ids}) do
      { :error, changeset } ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ChangesetView, "error.json", changeset: changeset)
        |> halt
      { :ok, private_event } ->
        private_event = private_event |> Repo.preload([:place, :consumer, private_event_participations: [:consumer], private_event_invitations: [:consumer]])

        reminders = CreateReminder.call!(%{type: "privateEventInvitationReminder", invitations: private_event.private_event_invitations})
        |> Repo.preload([private_event_invitation: [private_event: [:place, :consumer, private_event_invitations: [:consumer], private_event_participations: [:consumer]]]])

        reminders |> Enum.each(fn(r) ->
          NotificationChannel.new_reminder_created(r)
        end)

        ## send push notification
        host = private_event.consumer
        SendPushNotification.call(%{type: "private_event_invitation", host: host, private_event_invitations: private_event.private_event_invitations})

        conn |> assign(:new_private_event, private_event)
    end
  end

  defp create_private_event(conn, _options) do
    current_consumer = conn.assigns.current_consumer
    params = conn.params |> to_atom_keys
    case CreatePrivateEvent.call(%{name: params.name, date: params.date, from: params.from, place_id: params.place_id, consumer_id: current_consumer.id}) do
      { :error, changeset } ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ChangesetView, "error.json", changeset: changeset)
        |> halt
      { :ok, private_event } ->
        private_event = private_event |> Repo.preload([:place, :consumer, private_event_participations: [:consumer], private_event_invitations: [:consumer]])
        conn |> assign(:new_private_event, private_event)
    end
  end
end
