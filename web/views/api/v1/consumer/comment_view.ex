defmodule Playdays.Api.V1.Consumer.CommentView do
  use Playdays.Web, :view

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, __MODULE__, "comment.json")}
    # %{data: render_many(sessions, __MODULE__, "session_lite.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, __MODULE__, "comment.json")}
  end
  #
  # def render("session_lite.json", %{session: session}) do
  #   _render_lite(session)
  # end

  def render("comment.json", %{comment: comment}) do
    _render(comment)
  end

  defp _render(comment) do
    %{
      id: comment.id,
      text_content: comment.text_content,
      user_fb_user_id: comment.member.id,
      user_fname: comment.member.fname,
      user_lname: comment.member.lname,
      place_id: comment.place_id,
      event_id: comment.event_id,
      trial_class_id: comment.trial_class_id,
      inserted_at: (comment.inserted_at |> Ecto.DateTime.to_erl |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
    }

  end

  #
  # defp _render_lite(session) do
  #   %{
  #     id: session.id,
  #     time_slot_id: session.time_slot_id,
  #     status: session.status,
  #   }
  # end

end
