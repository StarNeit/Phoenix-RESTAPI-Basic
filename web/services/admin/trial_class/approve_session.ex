defmodule Playdays.Services.Admin.TrialClass.ApproveSession do

  alias Playdays.Repo
  alias Playdays.Session
  alias Playdays.Services.Consumer.Reminder.CreateReminder

  def call(session) do
    with(
      {:ok, session} <- Session.changeset(session, %{status: "joined"}) |> Repo.update,
      {:ok, reminder} <- CreateReminder.joined_trial_class_reminder(session),
      do: {:ok, {session, reminder}}
    )
  end

end
