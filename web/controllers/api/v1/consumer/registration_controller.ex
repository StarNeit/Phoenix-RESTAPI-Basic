defmodule Playdays.Api.V1.Consumer.RegistrationController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.Services.Consumer.Consumer.RegisterConsumer
  alias Playdays.Repo

  plug :scrub_params, "email" when action in [:create]
  plug :register_consumer when action in [:create]

  def create(conn, _consumer_params) do
    conn
    |> put_status(:created)
    |> put_resp_header("location", api_v1_consumer_registration_path(conn, :create))
    |> render("show.json", consumer: conn.assigns.current_consumer)
  end

  defp register_consumer(conn, _options) do
    device_uuid = conn |> get_req_header("x-device-uuid") |> List.first
    fb_user_id = conn |> get_req_header("x-fb-user-id") |> List.first
    fb_access_token = conn |> get_req_header("x-fb-access-token") |> List.first
    params = Map.merge(conn.params , %{
                  device_uuid: device_uuid,
                  fb_user_id: fb_user_id,
                  fb_access_token: fb_access_token
                })
              |> to_atom_keys
    case RegisterConsumer.call(params) do
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Playdays.ChangesetView, "error.json", changeset: changeset)
        |> halt
      {:ok, consumer} ->
        conn |> assign(:current_consumer, preload_for_render(consumer))
    end
  end

  defp preload_for_render(consumer) do
    consumer
    |> Repo.preload([:region, :district])
  end
end
