defmodule Playdays.Services.Consumer.Comment.CreateComment do

  alias Playdays.Repo
  alias Playdays.Comment

  def call(comment_params) do
    %Comment{}
    |> Comment.changeset(comment_params)
    |> Repo.insert
  end
end
