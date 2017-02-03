defmodule Playdays.Api.V1.Consumer.TagController do
  use Playdays.Web, :controller
  # import Playdays.Utils.MapUtils

  alias Playdays.Api.V1.ErrorView
  alias Playdays.Tag
  alias Playdays.Queries.TagQuery

  def index(conn, _params) do
    tags = Tag |> TagQuery.sort_by(asc: :title) |> TagQuery.many

    conn |> render("index.json", tags: tags)
  end
end
