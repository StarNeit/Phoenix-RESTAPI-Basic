defmodule Playdays.Api.V1.Consumer.CategoryController do
  use Playdays.Web, :controller
  # import Playdays.Utils.MapUtils

  alias Playdays.Api.V1.ErrorView
  alias Playdays.Category
  alias Playdays.Queries.CategoryQuery

  def index(conn, _params) do
    categories = Category |> CategoryQuery.sort_by(asc: :title) |> CategoryQuery.many

    conn |> render("index.json", categories: categories)
  end
end
