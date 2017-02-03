defmodule Playdays.Api.V1.Consumer.PrivateEventView do
  use Playdays.Web, :view

  alias Playdays.Api.V1.Consumer.PlaceView
  alias Playdays.Api.V1.Consumer.ConsumerView
  alias Playdays.Api.V1.Consumer.PrivateEventParticipationView
  alias Playdays.Api.V1.Consumer.PrivateEventInvitationView

  @json_attrs ~W(id name inserted_at updated_at)a

  def render("index.json", %{private_events: private_events}) do
    %{ data: render_many(private_events, __MODULE__, "private_event_details.json")}
  end

  def render("show.json", %{private_event: private_event}) do
    %{ data: render_one(private_event, __MODULE__, "private_event_details.json") }
  end

  def render("private_event_lite.json", %{private_event: private_event}) do
    private_event
      |> _render_lite
  end

  def render("private_event_details.json", %{private_event: private_event}) do
    private_event
      |> _render_details
  end

  defp _render_lite(private_event) do
    private_event
      |> Map.take(@json_attrs)
      |> Map.put(:date, _render_date(private_event.date))
      |> Map.put(:from, _render_time(private_event.from))
      |> Map.put(:place, render_one(private_event.place, PlaceView, "place_lite.json"))
      |> Map.put(:host, render_one(private_event.consumer, ConsumerView, "consumer_lite.json"))
  end

  def _render_details(private_event) do
    private_event
      |> _render_lite
      |> Map.put(:date, _render_date(private_event.date))
      |> Map.put(:from, _render_time(private_event.from))
      |> Map.put(:place, render_one(private_event.place, PlaceView, "place_details.json"))
      |> Map.put(:host, render_one(private_event.consumer, ConsumerView, "consumer_lite.json"))
      |> Map.put(:private_event_participations, render_many(private_event.private_event_participations, PrivateEventParticipationView, "private_event_participation_details.json"))
      |> Map.put(:private_event_invitations, render_many(private_event.private_event_invitations, PrivateEventInvitationView, "private_event_invitation_lite.json"))
  end

  def _render_date(date) do
    ({date |> Ecto.Date.to_erl, {0, 0, 0}} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000
  end

  defp _render_time(time) do
    ({{1970, 1, 1}, time |> Ecto.Time.to_erl} |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000
  end
end
