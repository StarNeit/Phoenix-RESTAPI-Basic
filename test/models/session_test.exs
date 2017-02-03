defmodule Playdays.SessionTest do
  use Playdays.ModelCase

  alias Playdays.Repo
  alias Playdays.Session


  setup do
    consumers = create_list(2, :consumer)
    time_slots = create(:event).time_slots

    valid_session_attrs_0 = %{
      consumer_id: Enum.at(consumers, 0).id,
      time_slot_id: Enum.at(time_slots, 0).id,
    }
    valid_session_attrs_1 = %{
      consumer_id: Enum.at(consumers, 0).id,
      time_slot_id: Enum.at(time_slots, 1).id,
    }
    valid_session_attrs_2 = %{
      consumer_id: Enum.at(consumers, 1).id,
      time_slot_id: Enum.at(time_slots, 2).id,
    }
    invalid_session_attrs = %{
      consumer_id: Enum.at(consumers, 0).id,
    }

    {
      :ok,
      valid_session_attrs: %{
        v0: valid_session_attrs_0,
        v1: valid_session_attrs_1,
        v2: valid_session_attrs_2
      },
      invalid_session_attrs: invalid_session_attrs
    }
  end

  test "changeset with valid attributes", %{valid_session_attrs: attrs} do
    changeset = %Session{} |> Session.changeset(attrs.v0)
    assert changeset.valid?
    Repo.insert changeset

    changeset = %Session{} |> Session.changeset(attrs.v1)
    assert changeset.valid?
    Repo.insert changeset

    changeset = %Session{} |> Session.changeset(attrs.v2)
    assert changeset.valid?
    Repo.insert changeset
  end

  test "changeset with invalid attributes", %{invalid_session_attrs: invalid_session_attrs} do
    changeset = %Session{} |> Session.changeset(invalid_session_attrs)
    refute changeset.valid?
  end

  test "changeset with duplicated attributes", %{valid_session_attrs: %{v0: attrs}} do
    changeset = %Session{} |> Session.changeset(attrs)
    assert changeset.valid?
    {:ok, _} = Repo.insert changeset

    changeset = %Session{} |> Session.changeset(attrs)
    assert changeset.valid?

    {:error, _} = Repo.insert changeset
  end

  #test "insert session" do
  #   consumer = create(:consumer)
  #   time_slot = hd create(:event).time_slots
  #   request = %Session{}
  #     |> Session.changeset(%{
  #         consumer_id: consumer.id,
  #         time_slot_id: time_slot.id,
  #         state: "pending",
  #     })
  #     |> Repo.insert!
  #     |> Repo.preload([:consumer, :time_slot])

  # assert request.consumer
  #   assert request.time_slot
  # end
end
