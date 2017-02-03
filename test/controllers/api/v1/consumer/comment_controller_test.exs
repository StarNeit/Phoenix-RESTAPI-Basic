# defmodule Playdays.Api.V1.Consumer.CommentControllerTest do
#   use Playdays.ConnCase, async: true
#
#   import Playdays.Utils.MapUtils
#
#   alias Playdays.Queries.CommentQuery
#
#   setup do
#     consumer = create(:consumer)
#     device = hd(consumer.devices)
#
#     event = create(:event)
#     trial_class = create(:trial_class)
#     place = create(:place)
#
#     comments = [
#       create(:comment, trial_class: trial_class),
#       create(:comment, trial_class: trial_class),
#       create(:comment, event: event),
#       create(:comment, event: event),
#       create(:comment, place: place),
#       create(:comment, place: place)
#     ]
#
#     conn = conn()
#             |> put_req_header("accept", "application/json")
#             |> put_req_header("x-fb-user-id", consumer.fb_user_id)
#             |> put_req_header("x-device-uuid", device.uuid)
#             |> put_req_header("x-fb-access-token", device.fb_access_token)
#
#     {:ok, conn: conn, comments: comments, event: event, trial_class: trial_class, place: place, consumer: consumer}
#   end
#
#   test "list all comments for specific event ", %{conn: conn, event: event} do
#     expected_data =
#       CommentQuery.find_all_comments(%{event_id: event.id})
#       |> Enum.map(&expected_render/1)
#
#     conn = get conn, api_v1_consumer_comment_path(conn, :index, %{event_id: event.id})
#
#     response_data = json_response(conn, 200)["data"] |> to_atom_keys
#     assert conn.status == 200
#     assert Poison.encode!(response_data) == Poison.encode!(expected_data)
#   end
#
# #  test "user create a comment successfully", %{conn: conn, event: event, consumer: consumer} do
# #    data = %{
# #        event_id: event.id,
# #        consumer_id: consumer.id,
# #        text_content: "testing comment"
# #      }
#
# #    conn = post(conn, api_v1_consumer_comment_path(conn, :create), data)
#
# #    expected_data = CommentQuery.find_all
# #    |> List.last
# #    |> Repo.preload(:consumer)
# #    |> expected_render
#
#
# #    response_data = json_response(conn, 201)["data"] |> to_atom_keys
#
# #    assert Poison.encode!(response_data) == Poison.encode!(expected_data)
# #  end
#
#   defp expected_render(comment) do
#     %{
#       id: comment.id,
#       text_content: comment.text_content,
#       user_fb_user_id: comment.consumer.fb_user_id,
#       user_name: comment.consumer.name,
#       place_id: comment.place_id,
#       event_id: comment.event_id,
#       trial_class_id: comment.trial_class_id,
#       inserted_at: (comment.inserted_at |> Ecto.DateTime.to_erl |> Timex.DateTime.from_erl |> Timex.DateTime.to_seconds) * 1000,
#     }
#   end
#
#
# end
