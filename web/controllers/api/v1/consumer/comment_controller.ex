defmodule Playdays.Api.V1.Consumer.CommentController do
  require Logger

  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.Api.V1.ErrorView
  alias Playdays.ChangesetView
  alias Playdays.Queries.CommentQuery
  alias Playdays.Services.Consumer.Comment.CreateComment

  # plug :scrub_params, "requestee_id" when action in [:create]
  # plug :scrub_params, "requester_id" when action in [:update]

  plug :create_comment when action in [:create]

  def index(conn, _params) do
    params = conn.params |> to_atom_keys
    comments = CommentQuery.find_all_comments params
    conn |> render("index.json", comments: comments)
  end

  def create(conn, _params) do
    Logger.debug "Loggin this text!"
    comment = conn.assigns.new_comment |> Repo.preload(:member)
    
    conn
    |> put_status(:created)
    |> put_resp_header("location", api_v1_consumer_comment_path(conn, :create))
    |> render("show.json", comment: conn.assigns.new_comment)
  end

  defp create_comment(conn, _params) do
    conn.params
    |> to_atom_keys
    |> Map.put(:member_id, conn.assigns.current_consumer.id)
    |> CreateComment.call
    |> handle_result(conn)
  end

  defp handle_result({:error, changeset}, conn) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(ChangesetView, "error.json", changeset: changeset)
    |> halt
  end

  defp handle_result({:ok, new_comment}, conn) do
    new_comment =
      new_comment
      |> Repo.preload([:member])
    conn |> assign(:new_comment, new_comment)
  end

end
