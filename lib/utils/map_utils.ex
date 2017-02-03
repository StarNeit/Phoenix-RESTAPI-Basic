defmodule Playdays.Utils.MapUtils do

  def to_atom_keys(input) when is_map(input) do
    if Enumerable.impl_for input do
      for {key, val} <- input, into: %{} do
        cond do
          is_atom(key) ->
            {
              key, to_atom_keys(val)
            }
          is_bitstring(key) ->
            {
              String.to_atom(key), to_atom_keys(val)
            }
        end
      end
    else
      input
    end
  end

  def to_atom_keys(input) when is_list(input) do
    Enum.map(input, &to_atom_keys(&1))
  end

  def to_atom_keys(input) when not is_map(input) do
    input
  end

  def to_atom_vals(map) do
    for {key, val} <- map, into: %{} do
      cond do
        is_atom(val) ->
          {
            key, val
          }
        is_bitstring(val) ->
          {
            key, val |> String.to_atom
          }
      end
    end
  end

  def to_string_keys(input) when not is_map(input), do: nil
  def to_string_keys(input) when is_map(input) do
    Enum.reduce(input, %{}, fn({k, v}, acc) ->
      cond do
        is_atom(k) ->
          acc |> Map.put(k |> Atom.to_string, v)
        is_bitstring(k) ->
          acc |> Map.put(k, v)
      end
    end)
  end

  def to_string_vals(map) do
    for {key, val} <- map, into: %{} do
      cond do
        is_atom(val) ->
          {
            key, val |> Atom.to_string
          }
        true ->
          {
            key, val
          }
      end
    end
  end
end
