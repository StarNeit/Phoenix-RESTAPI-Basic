defmodule Playdays.Api.V1.Consumer.PrivateEventParticipationView do
  use Playdays.Web, :view

  alias Playdays.Api.V1.Consumer.ConsumerView

  @json_attrs ~W(id private_event_id consumer_id inserted_at updated_at)a

  def render("index.json", %{private_event_participation: private_event_participation}) do
    %{ data: render_many(private_event_participation, __MODULE__, "private_event_participation_details.json")}
  end


  def render("show.json", %{private_event_participation: private_event_participation}) do
    %{ data: render_one(private_event_participation, __MODULE__, "private_event_participation_details.json") }
  end

  def render("private_event_participation_lite.json", %{private_event_participation: private_event_participation}) do
    private_event_participation
      |> _render_lite
  end

  def render("private_event_participation_details.json", %{private_event_participation: private_event_participation}) do
    private_event_participation
      |> _render_details
  end

  def _render_lite(private_event_participation) do
    private_event_participation
      |> Map.take(@json_attrs)
  end

  def _render_details(private_event_participation) do
    private_event_participation
      |> _render_lite
      |> Map.put(:consumer, render_one(private_event_participation.consumer, ConsumerView, "consumer_lite.json"))
  end

end
