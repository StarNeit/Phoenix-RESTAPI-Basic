defmodule Playdays.Api.V1.Consumer.SessionView do
  use Playdays.Web, :view

  alias Playdays.Api.V1.Consumer.TimeSlotView

  def render("index.json", %{sessions: sessions}) do
    %{data: render_many(sessions, __MODULE__, "session.json")}
    # %{data: render_many(sessions, __MODULE__, "session_lite.json")}
  end

  def render("show.json", %{session: session}) do
    %{data: render_one(session, __MODULE__, "session.json")}
  end
  #
  # def render("session_lite.json", %{session: session}) do
  #   _render_lite(session)
  # end

  def render("session.json", %{session: session}) do
    _render(session)
  end

  defp _render(session) do
    %{
      id: session.id,
      status: session.status,
    }
    |> Map.put(:time_slot, render_one(session.time_slot, TimeSlotView, "time_slot.json"))
  end

  #
  # defp _render_lite(session) do
  #   %{
  #     id: session.id,
  #     time_slot_id: session.time_slot_id,
  #     status: session.status,
  #   }
  # end

end
