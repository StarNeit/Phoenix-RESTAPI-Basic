defmodule Playdays.Services.Admin.TrialClass.UpdateTrialClass do

  alias Playdays.Repo
  alias Playdays.TrialClass

  def call(trial_class, trial_class_params) do
    TrialClass.changeset(trial_class, trial_class_params) |> Repo.update
  end

end
