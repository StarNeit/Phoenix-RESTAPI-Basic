defmodule Playdays.Queries.TrialClassQuery do
  import Ecto.Query

  alias Playdays.TrialClass
  alias Playdays.TimeSlot
  use Playdays.Query, model: TrialClass

  def all_trial_class() do
    time_slots =
      TimeSlot
      |> where([t], not(is_nil(t.trial_class_id)))
      |> many(sort_by: [asc: :date, asc: :from])
    trial_class_ids = Enum.map(time_slots, &Map.fetch!(&1, :trial_class_id)) |> Enum.uniq
    trial_classs =
      TrialClass
      |> where([e], e.id in ^trial_class_ids)
      |> many

    {trial_classs, time_slots}
  end

end
