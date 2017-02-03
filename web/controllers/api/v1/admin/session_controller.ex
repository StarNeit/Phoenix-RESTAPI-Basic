defmodule Playdays.Api.V1.Admin.SessionController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.Repo
  alias Playdays.Queries.SessionQuery
  alias Playdays.Services.Admin.TrialClass.ApproveSession
  alias Playdays.Services.Admin.TrialClass.RejectSession
  alias Playdays.Consumer.NotificationChannel
  alias Playdays.Services.Consumer.PushNotification.SendPushNotification

  plug :scrub_params, "approve_ids" when action in [:update]
  plug :scrub_params, "reject_ids" when action in [:update]
  plug :put_sessions when action in [:update]
  plug :update_sessions when action in [:update]

  def index(conn, _params) do
    status = conn.params["status"]
    sessions =
      if is_nil(status) || status == "undefined" do
        SessionQuery.find_many(%{}, preload: [:consumer, time_slot: [:trial_class, :event]])
      else
        SessionQuery.find_many(%{status: status}, preload: [:consumer, time_slot: [:trial_class, :event]])
      end

    render(conn, "index.json", sessions: sessions)
  end

  def update(conn, _admin_params) do
    send_resp conn, :no_content, "OK"
  end

  defp put_sessions(conn, _params) do
    params = conn.params
    approve_sessions = Enum.map(
      params["approve_ids"],
      &SessionQuery.find_one(%{id: &1}, preload: [time_slot: [:event, :trial_class]])
    )
    reject_sessions = Enum.map(
      params["reject_ids"],
      &SessionQuery.find_one(%{id: &1}, preload: [time_slot: [:event, :trial_class]])
    )
    all_sessions = approve_sessions ++ reject_sessions
    if Enum.all?(all_sessions, &!is_nil(&1)) do
      conn
      |> assign(:approve_sessions, approve_sessions)
      |> assign(:reject_sessions, reject_sessions)
    else
      non_exists_ids =
        all_sessions
        |> Enum.zip(params["approve_ids"] + params["reject_ids"])
        |> Enum.filter(&is_nil(elem(&1, 0)))
        |> Keyword.get_values(:nil)

      conn
      |> put_status(:not_found)
      |> render(
        ErrorView,
        "404.json",
        %{
          message: [
            "session with the following id does not exists",
            non_exists_ids
          ]
        }
      )
      |> halt
    end
  end

  defp update_sessions(conn, _params) do
    sessions =
      Enum.map(conn.assigns.approve_sessions, &ApproveSession.call/1) ++
      Enum.map(conn.assigns.reject_sessions, &RejectSession.call/1)
    sessions
    |> Enum.map(&notify_consumer_update/1)
    |> Enum.all?
    |> if do
    # if Enum.all?(sessions, &(elem(&1,0) == :ok)) do
      conn
    else
      error_session_ids =
        sessions
        |> Enum.zip(conn.assigns.approve_sessions ++ conn.assigns.reject_sessions)
        |> Enum.filter(&(elem(&1,0) == :error))
        |> Enum.map(&(elem(&1,1).id))

      conn
      |> put_status(:not_found)
      |> render(
        ErrorView,
        "422.json",
        %{
          errors: [
            "session with the following id cannot be update",
            error_session_ids
          ]
        }
      )
      |> halt
    end
  end

  defp notify_consumer_update({:error, _}) do
    false
  end

  defp notify_consumer_update({:ok, {session, reminder}}) do
    session = session |> Repo.preload([:consumer])
    if session.status == "joined" do

      NotificationChannel.session_approved(session)
      ### send push notification
      SendPushNotification.call(%{type: "joined_trial_class", session: session})
      ###
      notify_consumer_new_reminder_created(reminder)
    else
      NotificationChannel.session_rejected(session)
      ### send push notification
      SendPushNotification.call(%{type: "rejected_trial_class", session: session})
      ###
      notify_consumer_new_reminder_created(reminder)
    end
    true
  end

  defp notify_consumer_new_reminder_created(reminder) do
    Repo.preload(reminder, [
      :consumer,
      session: [:consumer, time_slot: [:event, :trial_class]],
    ])
    |> NotificationChannel.new_reminder_created
  end

end
