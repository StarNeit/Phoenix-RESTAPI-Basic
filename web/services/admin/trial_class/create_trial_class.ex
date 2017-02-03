defmodule Playdays.Services.Admin.TrialClass.CreateTrialClass do

  alias Playdays.Repo
  alias Playdays.TrialClass
  alias Playdays.TimeSlot

  alias Playdays.Queries.TrialClassQuery

  def call(class_params) do
    class = %TrialClass{}
    |> TrialClass.changeset(class_params)
    |> Repo.insert
    with {:ok, class} <- class do
      {:ok, Repo.preload(class, [:time_slots])}
    end
  end

end
