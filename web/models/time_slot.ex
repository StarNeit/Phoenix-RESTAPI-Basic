defmodule Playdays.TimeSlot do
  use Playdays.Web, :model

  schema "time_slots" do
    field :date,        Ecto.Date
    field :from,        Ecto.Time
    field :to,          Ecto.Time

    # no assoc_constraint, to achieve some what polymorphic
    belongs_to :event,  Playdays.Event
    belongs_to :trial_class,  Playdays.TrialClass

    many_to_many :joined_consumer, Playdays.Consumer, join_through: Playdays.Session,
    join_keys: [time_slot_id: :id, consumer_id: :id], on_replace: :delete, on_delete: :delete_all

    timestamps
  end

  @required_fields [:date, :from, :to]
  @assoc [:event_id, :trial_class_id]
  @whitelist_fields @required_fields ++ @assoc ++ []

  def changeset(model, params \\ :empty) do
    model
    |> cast(preprocess(params), @whitelist_fields)
    |> validate_required(@required_fields)
  end

  defp preprocess(time_slot_params) do
    time_slot_params
    |> Map.update(:date, "nil", &parse_date/1)
    |> Map.update(:from, "nil", &parse_time/1)
    |> Map.update(:to, "nil", &parse_time/1)
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
