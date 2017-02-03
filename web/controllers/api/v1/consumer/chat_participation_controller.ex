defmodule Playdays.Api.V1.Consumer.ChatParticipationController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.Api.V1.ErrorView

  alias Playdays.ChatParticipation
  alias Playdays.Queries.ChatParticipationQuery
  alias Playdays.Consumer.NotificationChannel

  plug :scrub_params, "last_read_chat_message_id" when action in [:update]

  plug :create_chat_participation when action in [:create]
  plug :put_chat_participation when action in [:update, :show]
  plug :update_chat_participation when action in [:update]

  def show(conn, _params) do
    chat_participation = conn.assigns.chat_participation |> Repo.preload(:consumer)
    render(conn, "show.json", chat_participation: chat_participation)
  end

  def create(conn, _params) do
    conn
    |> put_status(:created)
    |> render("show.json", chat_participation: conn.assigns.chat_participation)
  end

  def update(conn, _params) do
    chat_participation = conn.assigns.updated_chat_participation
    conn
    |> put_status(:ok)
    |> put_resp_header("location", api_v1_consumer_chat_participation_path(conn, :update, chat_participation))
    |> render("show.json", chat_participation: chat_participation)
  end

  defp put_chat_participation(conn, _params) do
    id = conn.params["id"]
    query = ChatParticipationQuery.find_one(%{id: id}, preload: [:chat_messages])

    case query do
      nil ->
        conn
          |> put_status(:not_found)
          |> render(ErrorView, "404.json")
      chat_participation ->
        conn |> assign(:chat_participation, chat_participation)
    end
  end

  defp update_chat_participation(%{params: %{"last_read_chat_message_id" => last_read_chat_message_id}} = conn, _options) do
    chat_participation = conn.assigns.chat_participation
    changeset = chat_participation |> ChatParticipation.changeset(%{last_read_chat_message_id: last_read_chat_message_id})

    case changeset |> Repo.update do
      { :error, changeset } ->
        conn
         |> put_status(:not_found)
         |> render(ErrorView, "404.json")
      {:ok, updated_chat_participation } ->
        updated_chat_participation = updated_chat_participation |> Repo.preload(:consumer)
        conn |> assign(:updated_chat_participation, updated_chat_participation)
    end
  end

  defp create_chat_participation(%{params: params} = conn, _options) do
    changeset_params = Map.take params, ["consumer_id", "chatroom_id"]
    %ChatParticipation{}
    |> ChatParticipation.changeset(changeset_params)
    |> Repo.insert
    |> case do
      { :error, changeset } ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
        |> halt
      {:ok, chat_participation } ->
        chat_participation = chat_participation |> Repo.preload(:consumer)
        conn |> assign(:chat_participation, chat_participation)
    end
  end
end
