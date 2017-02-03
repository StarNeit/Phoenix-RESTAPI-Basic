defmodule Playdays.PushNotificationClient.GenServer do
  use GenServer

  alias Playdays.PushNotificationClient

  defmacro __using__(_) do
    quote do
      import Playdays.PushNotificationClient.GenServer

      def notify_ios(params) do
        notify_ios(:playdays_push_client, params)
      end

      def notify_android(params) do
        notify_android(:playdays_push_client, params)
      end
    end
  end

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, [name: :playdays_push_client])
  end

  def notify_ios(server, params) do
    GenServer.cast(server, {:notify_ios, params})
  end

  def notify_android(server, params) do
    GenServer.cast(server, {:notify_android, params})
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast({:notify_ios, params}, state) do
    PushNotificationClient.notify_ios(params)
    {:noreply, state}
  end

  def handle_cast({:notify_android, params}, state) do
    PushNotificationClient.notify_android(params)
    {:noreply, state}
  end

  def handle_cast(request, state) do
    super(request, state)
  end
end
