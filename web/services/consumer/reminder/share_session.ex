defmodule Playdays.Services.Consumer.Reminder.ShareSession do

  alias Playdays.Queries.ConsumerQuery, as: FindConsumer
  alias Playdays.Services.Consumer.Reminder.CreateReminder

  def call(session, friends_consumer_ids) do
    friends_consumer_ids
    |> Enum.map(&CreateReminder.shared_session_reminder(&1, session))
  end

end
