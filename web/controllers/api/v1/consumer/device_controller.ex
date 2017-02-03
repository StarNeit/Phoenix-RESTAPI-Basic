defmodule Playdays.Api.V1.Consumer.DeviceController do
  use Playdays.Web, :controller
  import Playdays.Utils.MapUtils

  alias Playdays.ErrorView
  alias Playdays.ChangesetView
  alias Playdays.Consumer
  alias Playdays.Services.Consumer.Device.UpdateDevice

  plug :update_device when action in [:update]

  def update(conn, _body_params) do
    conn
    |> put_status(:ok)
    |> render("show.json", %{device: conn.assigns.updated_device})
  end

  defp update_device(conn, _opts) do
    params = conn.params |> to_atom_keys
    uuid = params.uuid
    device_token = params.device_token
    platform = params.platform
    consumer = conn.assigns.current_consumer
    device = consumer |> Consumer.find_device(%{uuid: uuid})
    case UpdateDevice.call(%{consumer: consumer, device: device, device_token: device_token, platform: platform}) do
      {:ok, device} ->
        conn
          |> assign(:updated_device, device)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ChangesetView, "error.json", changeset: changeset)
        |> halt
    end
  end
end
