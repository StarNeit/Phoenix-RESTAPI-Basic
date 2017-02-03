defmodule Playdays.Api.V1.Admin.CommentController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.Queries.CommentQuery
  alias Playdays.Api.V1.Helper

  plug :scrub_params, "id" when action in [:delete]
  plug :put_comment when action in [:delete]

  def index(conn, _params) do
    comments =
      conn.params
      |> to_atom_keys
      |> CommentQuery.find_all_comments
    conn |> render("index.json", comments: comments)
  end

  def delete(conn, _params) do
    Repo.delete!(conn.assigns.comment)
    send_resp(conn, :no_content, "")
  end

  def put_comment(conn, _params) do
    CommentQuery.find_one(%{id: conn.params["id"]})
    |> Helper.assign_or_404(conn, :comment)
  end

end
