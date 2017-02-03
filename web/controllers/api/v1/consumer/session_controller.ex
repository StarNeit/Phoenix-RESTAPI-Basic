defmodule Playdays.Api.V1.Consumer.SessionController do
  use Playdays.Web, :controller

  alias Playdays.ChangesetView
  alias Playdays.Event
  alias Playdays.Queries.TimeSlotQuery
  alias Playdays.Queries.SessionQuery
  alias Playdays.Repo
  alias Playdays.Services.Consumer.Consumer.JoinSession
  alias Playdays.Services.Consumer.Reminder.CreateReminder
  alias Playdays.Services.Consumer.Reminder.ShareSession
  alias Playdays.Api.V1.Helper
  alias Playdays.Consumer.NotificationChannel, as: NotifyConsumer

  plug :scrub_params, "time_slot_id" when action in [:create]
  plug :scrub_params, "id" when action in [:share_with_friends]
  plug :scrub_params, "friends_consumer_ids" when action in [:share_with_friends]
  plug :put_time_slot when action in [:create]
  plug :put_session when action in [:share_with_friends]

  def index(conn, _params) do
    sessions =
      # SessionQuery.find_many(
      #   %{consumer_id: conn.assigns.current_consumer.id},
      # #   preload: [time_slot: [:event, :trial_class]]
      # )

      SessionQuery.find_sessions(
        %{consumer_id: conn.assigns.current_consumer.id}
      )
    render conn, "index.json", sessions: sessions
  end

  def create(conn, _params) do
    case JoinSession.call(conn.assigns.time_slot, conn.assigns.current_consumer) do
      {:ok, session} ->
        if session.status == "joined" do
          session = Repo.preload session, [time_slot: [:event]]
          event = Event.update_joined_consumer_number(session.time_slot.event, +1)
          session = put_in(session.time_slot.event, event)
          case CreateReminder.joined_public_event_reminder(session) do
            {:ok, _reminder} ->
              render(conn, "show.json", session: session)
            {:error, changeset} ->
              conn
              |> put_status(:unprocessable_entity)
              |> render(ChangesetView, "error.json", changeset: changeset)
          end
        else
          render(conn, "show.json", session: session |> Repo.preload([time_slot: [:trial_class]]))
        end
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ChangesetView, "error.json", changeset: changeset)
    end
  end

  def share_with_friends(conn, _params) do
    ShareSession.call(conn.assigns.session, conn.params["friends_consumer_ids"])
    |> Enum.map(&notify_friend(&1, conn.assigns.session))
    |> Enum.drop_while(&is_nil/1)
    |> share_send_resp(conn)
  end

  defp put_time_slot(conn, params) do
    TimeSlotQuery.find_one(%{id: conn.params["time_slot_id"]})
    |> Helper.assign_or_404(conn, :time_slot)
  end

  defp put_session(conn, params) do
    SessionQuery.find_one(%{id: conn.params["id"]}, preload: [:consumer, time_slot: [:event, :trial_class]])
    |> Helper.assign_or_404(conn, :session)
  end

  defp notify_friend({:error, changeset}, _) do
    {:error, changeset}
  end

  defp notify_friend({:ok, reminder}, session) do
    reminder
    |> Map.put(:session, session)
    |> NotifyConsumer.new_reminder_created
    nil
  end

  defp share_send_resp([], conn) do
    send_resp(conn, :no_content, "")
  end

  defp share_send_resp([{:error, changeset}|_], conn) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(ChangesetView, "error.json", changeset: changeset)
  end
end
