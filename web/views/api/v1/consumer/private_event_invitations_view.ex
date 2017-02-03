defmodule Playdays.Api.V1.Consumer.PrivateEventInvitationView do
  use Playdays.Web, :view

  alias Playdays.Api.V1.Consumer.ConsumerView
  alias Playdays.Api.V1.Consumer.PrivateEventView

  @json_attrs ~W(id private_event_id state consumer_id inserted_at updated_at)a

  def render("index.json", %{private_event_invitations: private_event_invitations}) do
    %{ data: render_many(private_event_invitations, __MODULE__, "private_event_invitation_details.json")}
  end

  def render("show.json", %{private_event_invitation: private_event_invitation}) do
    %{ data: render_one(private_event_invitation, __MODULE__, "private_event_invitation_details.json") }
  end

  def render("private_event_invitation_lite.json", %{private_event_invitation: private_event_invitation}) do
    private_event_invitation
      |> _render_lite
  end

  def render("private_event_invitation_details.json", %{private_event_invitation: private_event_invitation}) do
    private_event_invitation
      |> _render_details
  end

  defp _render_lite(private_event_invitation) do
    private_event_invitation
    |> Map.take(@json_attrs)
    |> Map.put(:consumer, render_one(private_event_invitation.consumer, ConsumerView, "consumer_lite.json"))
  end

  def _render_details(private_event_invitation) do
    private_event_invitation
    |> _render_lite
    |> Map.put(:private_event, render_one(private_event_invitation.private_event, PrivateEventView, "private_event_details.json"))
  end

end
