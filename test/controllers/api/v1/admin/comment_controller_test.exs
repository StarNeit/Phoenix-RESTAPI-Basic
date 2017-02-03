defmodule Playdays.Api.V1.Admin.CommentControllerTest do
  use Playdays.ConnCase, async: false
  import Playdays.Utils.MapUtils

  alias Playdays.Queries.CommentQuery

  setup do
    admin = create(:admin)
    conn =
      conn()
      |> put_req_header("accept", "application/json")
      |> put_req_header("x-auth-token", admin.authentication_token)


    event = create(:event)
    # trial_class = create(:trial_class)
    # place = create(:place)

    comments = [
      create(:comment, event: event),
      create(:comment, event: event),
      # create(:comment, trial_class: trial_class),
      # create(:comment, trial_class: trial_class),
      # create(:comment, place: place),
      # create(:comment, place: place)
    ]

    {:ok, conn: conn, comments: comments}
  end

#  test "list comment", %{conn: conn, comments: comments} do
#    data = Map.take hd(comments), [:event_id]
#    conn = get conn, api_v1_admin_comment_path(conn, :index, data)
#    response_data = json_response(conn, 200) ["data"] |> to_atom_keys

#    expected_data = Enum.map(comments, &expected_data/1)

#    assert response_data == expected_data
#  end

  # test "can delete comment", %{conn: conn, comments: [comment|_] = comments} do
  #   conn
  #   |> delete(api_v1_admin_comment_path(conn, :delete, comment))
  #   |> assert_status(204)
  #   assert length(comments) - 1 == length(CommentQuery.find_all)
  # end

#  defp expected_data(comment) do
#    %{
#      id: comment.id,
#      text_content: comment.text_content,
#      # user_fb_user_id: comment.consumer.fb_user_id,
#      user_name: comment.consumer.name,
#      place_id: comment.place_id,
#      event_id: comment.event_id,
#      trial_class_id: comment.trial_class_id,
#      inserted_at: (comment.inserted_at |> Ecto.DateTime.to_erl |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
#    }
#  end

end
