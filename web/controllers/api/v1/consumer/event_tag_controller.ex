defmodule Playdays.Api.V1.Consumer.EventTagController do
  use Playdays.Web, :controller
  # import Playdays.Utils.MapUtils

  alias Playdays.Api.V1.ErrorView
  alias Playdays.EventTag
  alias Playdays.Queries.EventTagQuery

  def index(conn, _params) do
    event_tags = EventTag |> EventTagQuery.sort_by(asc: :title) |> EventTagQuery.many

    conn |> render("index.json", event_tags: event_tags)
  end
end
