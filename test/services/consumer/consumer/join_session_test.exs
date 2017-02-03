defmodule Playdays.Services.Consumer.Session.JoinSessionTest do
  use Playdays.ModelCase, async: false

  alias Playdays.Repo
  alias Playdays.Services.Consumer.Consumer.JoinSession


  setup do
    consumer = create(:consumer)
    event_time_slot = hd create(:event).time_slots
    class_time_slot = hd create(:event).time_slots
    {:ok, consumer: consumer, event_time_slot: event_time_slot, class_time_slot: class_time_slot}
  end

  test "consumer can join a session", %{consumer: consumer, event_time_slot: event_time_slot} do
    {:ok, request} = JoinSession.call(event_time_slot, consumer)

    consumer = consumer |> Repo.preload(:joined_sessions)
    event_time_slot = event_time_slot |> Repo.preload(:joined_consumer)

    assert request.status == "joined"
    assert 1 == length consumer.joined_sessions
    assert 1 == length event_time_slot.joined_consumer
  end

  test "consumer can join a session", %{consumer: consumer, class_time_slot: class_time_slot} do
    {:ok, request} = JoinSession.call(class_time_slot, consumer)

    consumer = consumer |> Repo.preload(:joined_sessions)
    class_time_slot = class_time_slot |> Repo.preload(:joined_consumer)

    consumer_joined_sessions_count = length consumer.joined_sessions
    class_time_slot_joined_consumer_count = length class_time_slot.joined_consumer

    assert request.status == "pending"
    assert 1 == length consumer.joined_sessions
    assert 1 == length class_time_slot.joined_consumer
  end

end
