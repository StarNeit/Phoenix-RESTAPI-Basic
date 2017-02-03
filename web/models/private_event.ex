defmodule Playdays.PrivateEvent do
  use Playdays.Web, :model

  schema "private_events" do
    field :name,                        :string
    field :date,        Ecto.Date
    field :from,        Ecto.Time

    belongs_to :place, Playdays.Place
    belongs_to :consumer, Playdays.Consumer
    has_many :private_event_invitations, Playdays.PrivateEventInvitation
    has_many :private_event_participations, Playdays.PrivateEventParticipation

    timestamps
  end

  @required_fields [:name, :date, :from, :place_id, :consumer_id]
  @whitelist_fields @required_fields ++ []

  def changeset(model, params \\ :empty) do
    model
    |> cast(preprocess(params), @whitelist_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:private_event_invitations, required: false)
    |> cast_assoc(:private_event_participations, required: false)
    |> assoc_constraint(:place)
    |> assoc_constraint(:consumer)
  end

  def add_private_event_participation(model, private_event_participation) do
    private_event_participations = model.private_event_participations ++ [private_event_participation]
    changeset = Enum.map(private_event_participations, &Ecto.Changeset.change/1)
    model |> put_private_event_participations_assoc(changeset)
  end

  defp put_private_event_participations_assoc(model, changeset) do
    model
      |> Ecto.Changeset.change
      |> Ecto.Changeset.put_assoc(:private_event_participations, changeset)
  end

  def preprocess(params) do
    params
    |> Map.update(:date, "nil", &parse_date/1)
    |> Map.update(:from, "nil", &parse_time/1)
  end

  defp parse_time(since_epoch) do
    Timex.DateTime.from_milliseconds(since_epoch)
    |> Timex.to_erlang_datetime
    |> elem(1)
    |> Ecto.Time.from_erl
  end

  defp parse_date(since_epoch) do
    Timex.DateTime.from_milliseconds(since_epoch)
    |> Timex.shift(hours: 8)
    |> Timex.to_erlang_datetime
    |> elem(0)
    |> Ecto.Date.from_erl
  end


end
