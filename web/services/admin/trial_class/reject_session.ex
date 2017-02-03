defmodule Playdays.Services.Admin.TrialClass.RejectSession do

  alias Playdays.Repo
  alias Playdays.Session
  alias Playdays.Services.Consumer.Reminder.CreateReminder

  def call(session) do
    with(
      {:ok, session} <- Session.changeset(session, %{status: "rejected"}) |> Repo.update,
      {:ok, reminder} <- CreateReminder.rejected_trial_class_reminder(session),
      do: {:ok, {session, reminder}}
    )
  end

end
