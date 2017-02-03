defmodule Playdays.Api.V1.Consumer.ReminderController do
  use Playdays.Web, :controller

  alias Playdays.Queries.ReminderQuery
  alias Playdays.ErrorView
  alias Playdays.Services.Consumer.Reminder.UpdateReminder
  alias Playdays.Api.V1.Helper

  # plug :scrub_params, "time_slot_id" when action in [:create]
  plug :put_reminder when action in [:archive, :mark_read]

  def index(conn, _params) do
    reminders = ReminderQuery.where_consumer_id_is conn.assigns.current_consumer.id

    # TODO put the logic to frontend maybe?
    reminders
    |> Enum.filter(& &1.state == "unread")
    |> Enum.map(&UpdateReminder.mark_read/1)
    # endTODO

    render conn, "index.json", reminders: reminders
  end

  def archive(conn, _params) do
    UpdateReminder.archive(conn.assigns.reminder)
    |> render_update_result(conn)
  end

  def mark_read(conn, _params) do
    UpdateReminder.mark_read(conn.assigns.reminder)
    |> render_update_result(conn)
  end

  defp put_reminder(conn, _params) do
    ReminderQuery.find_one(%{id: conn.params["id"]})
    |> Helper.assign_or_404(conn, :reminder)
  end

  defp render_update_result({:error, changeset}, conn) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
  end

  defp render_update_result({:ok, reminder}, conn) do
    render(conn, "show.json", reminder: reminder |> preload_for_view)
  end

  defp preload_for_view(reminder) do
    Repo.preload(reminder, [
      :consumer,
      friend_request: [:requester, :requestee],
      session: [:consumer, time_slot: [:event, :trial_class]],
    ])
  end

end
