defmodule Playdays.Api.V1.Admin.CommentView do
  use Playdays.Web, :view

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, __MODULE__, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, __MODULE__, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    _render(comment)
  end

  defp _render(comment) do
    %{
      id: comment.id,
      text_content: comment.text_content,
      # user_fb_user_id: comment.consumer.fb_user_id,
      user_name: comment.consumer.name,
      place_id: comment.place_id,
      event_id: comment.event_id,
      trial_class_id: comment.trial_class_id,
      inserted_at: (comment.inserted_at |> Ecto.DateTime.to_erl |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
    }

  end

end
