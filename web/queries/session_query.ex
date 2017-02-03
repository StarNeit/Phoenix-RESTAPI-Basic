defmodule Playdays.Queries.SessionQuery do
  import Ecto.Query

  use Playdays.Query, model: Playdays.Session

  def find_sessions(params) do
    scoped(params)
    |> join(:left, [s], c in assoc(s, :consumer))
    |> join(:left, [s], t in assoc(s, :time_slot))
    |> join(:left, [s, _, t], e in assoc(t, :event))
    |> join(:left, [s, _, t], tc in assoc(t, :trial_class))
    |> preload([s, c, t, e, tc], [:consumer, time_slot: {t, [event: e, trial_class: tc]}])
    |> many
  end
end
