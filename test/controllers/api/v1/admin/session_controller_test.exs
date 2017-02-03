defmodule Playdays.Api.V1.Admin.SessionControllerTest do
  import Mock
  use Playdays.ConnCase, async: false
  import Playdays.Utils.MapUtils


  alias Playdays.Queries.SessionQuery
  alias Playdays.Consumer.NotificationChannel
  alias Playdays.Queries.ReminderQuery

  setup do
    admin = create(:admin)
    conn = conn()
            |> put_req_header("accept", "application/json")
            |> put_req_header("x-auth-token", admin.authentication_token)


    time_slot = hd create(:trial_class).time_slots
    session = create(:session, time_slot: time_slot)
    {:ok, conn: conn, time_slot: time_slot, session: session}
  end

  test "list all pending session", %{conn: conn, time_slot: time_slot} do
    create(:session, time_slot: time_slot)

    sessions = SessionQuery.find_many(%{status: "pending"}, preload: [:consumer, time_slot: :trial_class])
    data = %{status: "pending"}
    conn = get conn, api_v1_admin_session_path(conn, :index, data)
    response_data = json_response(conn, 200) ["data"] |> to_atom_keys

    expected_data = Enum.map sessions, &expected_render/1

    assert Poison.encode!(response_data) == Poison.encode!(expected_data)
  end

  test "approve a session", %{conn: conn, session: session, time_slot: time_slot} do
    create(:session, time_slot: time_slot)

    data = %{
      approve_ids: [session.id],
      reject_ids: []
    }
    conn = put conn, api_v1_admin_session_path(conn, :update), data
    assert_status(conn, 204)

    joined_sessions = SessionQuery.find_many(%{status: "joined"})

    assert length(joined_sessions) == 1
    assert hd(joined_sessions).id == session.id
  end

  test "reject a session", %{conn: conn, session: session, time_slot: time_slot} do
    create(:session, time_slot: time_slot)

    data = %{
      approve_ids: [],
      reject_ids: [session.id]
    }
    conn = put conn, api_v1_admin_session_path(conn, :update), data
    assert_status(conn, 204)

    rejected_sessions = SessionQuery.find_many(%{status: "rejected"})

    assert length(rejected_sessions) == 1
    assert hd(rejected_sessions).id == session.id
  end

  test "reject two session", %{conn: conn, session: session, time_slot: time_slot} do
    session2 = create(:session, time_slot: time_slot)

    assert length(SessionQuery.find_many(%{status: "rejected"})) == 0

    data = %{
      approve_ids: [],
      reject_ids: [session.id, session2.id]
    }
    conn = put conn, api_v1_admin_session_path(conn, :update), data
    assert_status(conn, 204)

    rejected_sessions = SessionQuery.find_many(%{status: "rejected"})

    assert length(rejected_sessions) == 2
  end

#  test "approve session will notify consumer via channel", %{conn: conn, time_slot: time_slot} do
#    with_mock NotificationChannel, mocked_notification_channel_func_list do

#      session = create(:session, time_slot: time_slot)

#      data = %{
#        approve_ids: [session.id],
#        reject_ids: []
#      }
#      conn = put conn, api_v1_admin_session_path(conn, :update), data

 #     session = SessionQuery.find_one(%{id: session.id}, preload: [:consumer, time_slot: [:event, :trial_class]])
 #     assert called NotificationChannel.session_approved(session)
#    end
#  end

#  test "reject session will notify consumer via channel", %{conn: conn, time_slot: time_slot} do
#    with_mock NotificationChannel, mocked_notification_channel_func_list do

#     session = create(:session, time_slot: time_slot)

#      data = %{
#        approve_ids: [],
#        reject_ids: [session.id]
#      }
#      put conn, api_v1_admin_session_path(conn, :update), data

#      session = SessionQuery.find_one(%{id: session.id}, preload: [:consumer, time_slot: [:event, :trial_class]])
#      assert called NotificationChannel.session_rejected(session)
 #   end
#  end

#  test "approve session will create reminder", %{conn: conn, session: session, time_slot: time_slot} do
#    assert 0 == length ReminderQuery.find_many(%{consumer_id: session.consumer_id})

#    data = %{
#      approve_ids: [session.id],
#      reject_ids: []
#    }
#    put conn, api_v1_admin_session_path(conn, :update), data

#    reminders = ReminderQuery.find_many(%{consumer_id: session.consumer_id})
#    reminder = hd reminders
#    assert 1 == length reminders
#    assert reminder.consumer_id == session.consumer_id
#    assert reminder.session_id == session.id
#    assert reminder.reminder_type == "joinedTrialClassReminder"
#  end

#  test "reject session will create reminder", %{conn: conn, session: session, time_slot: time_slot} do
#    assert 0 == length ReminderQuery.find_many(%{consumer_id: session.consumer_id})

#    data = %{
#      approve_ids: [],
#      reject_ids: [session.id]
#    }
#    put conn, api_v1_admin_session_path(conn, :update), data

#    reminders = ReminderQuery.find_many(%{consumer_id: session.consumer_id})
#    reminder = hd reminders
#    assert 1 == length reminders
#    assert reminder.consumer_id == session.consumer_id
#    assert reminder.session_id == session.id
#    assert reminder.reminder_type == "rejectedTrialClassReminder"
#  end

#  test "approve session will broadcast reminder is created", %{conn: conn, time_slot: time_slot} do
#    with_mock NotificationChannel, mocked_notification_channel_func_list do

#      session = create(:session, time_slot: time_slot)
#      request_data = %{approve_ids: [session.id], reject_ids: []}
#      put conn, api_v1_admin_session_path(conn, :update), request_data

#      data = ReminderQuery.find_one(
#        %{consumer_id: session.consumer_id},
#        preload: [
#          :consumer,
#          session: [:consumer, time_slot: [:event, :trial_class]],
#        ]
#      )

#      assert called NotificationChannel.new_reminder_created(data)
#    end
#  end

#  test "reject session will broadcast reminder is created", %{conn: conn, time_slot: time_slot} do
#    with_mock NotificationChannel, mocked_notification_channel_func_list do

#      session = create(:session, time_slot: time_slot)
#      request_data = %{approve_ids: [], reject_ids: [session.id]}
#      put conn, api_v1_admin_session_path(conn, :update), request_data

#      data = ReminderQuery.find_one(
#        %{consumer_id: session.consumer_id},
#        preload: [
#          :consumer,
#          session: [:consumer, time_slot: [:event, :trial_class]],
#        ]
 #     )

#      assert called NotificationChannel.new_reminder_created(data)
#    end
#  end

  defp expected_render(session) do
    %{
      id: session.id,
      status: session.status,
      inserted_at: session.inserted_at,
      consumer: %{
        email: session.consumer.email,
        id: session.consumer.id,
        name: session.consumer.name,
      },
      time_slot: %{
        id: session.time_slot.id,
        date: ({session.time_slot.date |> Ecto.Date.to_erl, {0, 0, 0}} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
        from: ({{1970, 1, 2}, session.time_slot.from |> Ecto.Time.to_erl} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
        to: ({{1970, 1, 2}, session.time_slot.to |> Ecto.Time.to_erl} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
        trial_class: %{
          description: session.time_slot.trial_class.description,
          name: session.time_slot.trial_class.name,
          id: session.time_slot.trial_class.id,
          is_active: session.time_slot.trial_class.is_active,
        }
      }
    }
  end

  defp mocked_notification_channel_func_list() do
    [
      new_reminder_created: fn(_) -> {:ok, "things"} end,
      session_approved: fn(_) -> {:ok, "things"} end,
      session_rejected: fn(_) -> {:ok, "things"} end
    ]
  end

end
