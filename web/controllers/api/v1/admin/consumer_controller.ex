defmodule Playdays.Api.V1.Admin.ConsumerController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.Queries.ConsumerQuery

  def index(conn, _params) do
    consumers = ConsumerQuery.find_all
    conn |> render("index.json", consumers: consumers)
  end

end
