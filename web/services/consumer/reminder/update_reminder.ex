defmodule Playdays.Services.Consumer.Reminder.UpdateReminder do

  alias Playdays.Repo
  alias Playdays.Reminder

  def archive(reminder) do
    reminder
    |> Reminder.changeset(%{state: "archived"})
    |> Repo.update
  end

  def mark_read(reminder) do
    reminder
    |> Reminder.changeset(%{state: "read"})
    |> Repo.update
  end

end
