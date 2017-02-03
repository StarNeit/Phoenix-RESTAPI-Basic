defmodule Playdays.Api.V1.Consumer.FriendRequestController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.Api.V1.ErrorView
  alias Playdays.Consumer.NotificationChannel
  alias Playdays.Consumer
  alias Playdays.Queries.ConsumerQuery
  alias Playdays.Queries.FriendRequestQuery
  alias Playdays.Services.Consumer.FriendRequest.CreateFriendRequest
  alias Playdays.Services.Consumer.FriendRequest.AcceptFriendRequest
  alias Playdays.Services.Consumer.PushNotification.SendPushNotification

  plug :scrub_params, "requestee_id" when action in [:create]
  plug :scrub_params, "requester_id" when action in [:update]

  plug :put_requestee when action in [:create]
  plug :put_request when action in [:update]
  plug :put_requester when action in [:update]
  plug :create_friend_request when action in [:create]
  plug :update_friend_request when action in [:update]

  def index(conn, _params) do
    params = conn.params |> to_atom_keys
    consumer = conn.assigns.current_consumer |> Repo.preload([:outbound_friend_requests, :inbound_friend_requests])
    outbound_friend_requests = consumer.outbound_friend_requests
    inbound_friend_requests = consumer.inbound_friend_requests |> Repo.preload([requester: [:region, :district]])
    friend_requests = outbound_friend_requests ++ inbound_friend_requests

    conn |> render("index.json", friend_requests: friend_requests)
  end

  def create(conn, _params) do
    conn
    |> put_status(:created)
    |> put_resp_header("location", api_v1_consumer_friend_request_path(conn, :create))
    |> render("show.json", friend_request: conn.assigns.new_friend_request)
  end

  def update(conn, _params) do
    friend_request = conn.assigns.updated_friend_request
    conn
    |> put_status(:ok)
    |> put_resp_header("location", api_v1_consumer_friend_request_path(conn, :update, friend_request))
    |> render("show.json", friend_request: friend_request)
  end

  defp put_request(conn, _options) do
    params = conn.params |> to_atom_keys
    case FriendRequestQuery.find_one(%{id: params.id}) do
      nil ->
        conn
          |> put_status(:not_found)
          |> render(ErrorView, "404.json")
          |> halt
      request ->
        conn |> assign(:current_request, request)
    end
  end

  defp put_requester(conn, _options) do
    params = conn.params |> to_atom_keys
    case ConsumerQuery.find_one(%{id: params.requester_id}) do
      nil ->
        conn
          |> put_status(:not_found)
          |> render(ErrorView, "404.json")
          |> halt
      requester ->
        conn |> assign(:current_requester, requester)
    end
  end

  defp put_requestee(conn, _options) do
    params = conn.params |> to_atom_keys

    case ConsumerQuery.find_one(%{id: params.requestee_id}) do
      nil ->
        conn
          |> put_status(:not_found)
          |> render(ErrorView, "404.json")
          |> halt
      requestee ->
        conn |> assign(:current_requestee, requestee)
    end
  end

  defp create_friend_request(conn, _options) do
    requester = conn.assigns.current_consumer
    requestee = conn.assigns.current_requestee
    case CreateFriendRequest.call(%{requester: requester, requestee: requestee}) do
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
        |> halt
      {:ok, {new_friend_request, reminder}} ->
        new_friend_request = new_friend_request |> Repo.preload(:requester)
        NotificationChannel.new_friend_request_created(new_friend_request)
        notify_consumer_new_reminder_created(reminder, new_friend_request)

        ### Send Push Notification
        SendPushNotification.call(%{type: "new_friend_request", requestee: requestee, requester: requester})

        conn |> assign(:new_friend_request, new_friend_request)
    end
  end

  defp update_friend_request(%{params: %{"action_type" => "accept"}} = conn, _options) do
    request = conn.assigns.current_request
    requester = conn.assigns.current_requester
    requestee = conn.assigns.current_consumer
    case AcceptFriendRequest.call(%{request: request, requester: requester, requestee: requestee}) do
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
        |> halt
      {:ok, {updated_friend_request, reminder}} ->
        updated_friend_request = updated_friend_request |> Repo.preload(:requestee)
        NotificationChannel.friend_request_accepted(updated_friend_request)
        notify_consumer_new_reminder_created(reminder, updated_friend_request)

        ## send push notification
        SendPushNotification.call(%{type: "accepted_friend_request", requestee: requestee, requester: requester})
        conn |> assign(:updated_friend_request, updated_friend_request)
    end
  end

  defp notify_consumer_new_reminder_created(reminder, friend_request) do
    reminder
    |> Map.put(:friend_request, friend_request)
    |> NotificationChannel.new_reminder_created
  end

end
