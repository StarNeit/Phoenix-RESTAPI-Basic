defmodule Playdays.Ecto.Types.HashedField do
  @behaviour Ecto.Type

  def type, do: :binary

  def cast(value) do
    {:ok, value |> to_string}
  end

  def dump(value) do
    {:ok, value |> hash}
  end

  def load(value) do
    {:ok, value}
  end

  defdelegate hash(value), to: Playdays.Crypto, as: :sha256
end
