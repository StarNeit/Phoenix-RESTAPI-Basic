defmodule Playdays.Api.V1.Consumer.MeController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.Queries.ConsumerQuery
  alias Playdays.Consumer

  plug :update_me when action in [:update]

  def show(conn, _), do: conn |> renderShow
  def update(conn, _), do: conn |> renderShow

  defp perloadMeForView(%{id: id} = me) do
    me
    |> Repo.preload([:region, :district])
    |> Map.put(:friends_count, ConsumerQuery.count_friend(id))
  end

  defp renderShow(conn) do
    me = conn.assigns.current_consumer |> perloadMeForView
    conn
    |> put_status(:ok)
    |> render("show.json", me: me)
  end

  defp update_me(conn, _options) do
    conn.assigns.current_consumer
    # TODO investigate why this preload is here
    |> Repo.preload([:friends])
    |> Consumer.changeset(conn.params)
    |> Repo.update
    |> assign_updated_me(conn)
  end

  defp assign_updated_me({:error, changeset}, conn) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(ChangesetView, "error.json", changeset: changeset)
    |> halt
  end

  defp assign_updated_me({:ok, updated_me}, conn) do
    conn
    |> assign(:current_consumer, updated_me)
  end


end
