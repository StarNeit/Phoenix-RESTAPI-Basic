defmodule Playdays.Api.V1.Admin.ConsumerView do
  use Playdays.Web, :view

  @attrs ~W(id email name)a

  def render("index.json", %{consumers: consumers}) do
    %{ data: render_many(consumers, __MODULE__, "consumer.json") }
  end

  def render("consumer.json", %{consumer: consumer}) do
    consumer
    |> _render
  end

  defp _render(consumer) do
    consumer
    |> Map.take(@attrs)
  end

end
