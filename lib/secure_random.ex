defmodule Playdays.SecureRandom do

  @numerics ~w(0 1 2 3 4 5 6 7 8 9)
  @alphabet ~w(a b c d e f g h i j k l m n o p q r s t u v w x y z) ++
            ~w(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) ++
            @numerics

  def random_bytes(n) when is_integer n do
    n |> :crypto.strong_rand_bytes
  end

  def base64(n) when is_integer n do
    n
    |> random_bytes
    |> :base64.encode_to_string
    |> to_string
  end

  def uuid do
    bytes = random_bytes(16)
            |> :erlang.bitstring_to_list
    :io_lib.format("~2.16.0b~2.16.0b~2.16.0b~2.16.0b-~2.16.0b~2.16.0b-~2.16.0b~2.16.0b-~2.16.0b~2.16.0b~2.16.0b~2.16.0b~2.16.0b~2.16.0b~2.16.0b~2.16.0b", bytes)
    |> to_string
  end

  def integer(n) when is_integer n do
    :random.seed(:erlang.timestamp)
    :random.uniform(n)
    |> to_string
  end

  def alphanumeric(length) when is_integer length do
    :random.seed(:erlang.timestamp)
    Enum.join(for _ <- 1..length, do: Enum.random(@alphabet))
  end

  def numeric(length) when is_integer length do
    :random.seed(:erlang.timestamp)
    Enum.join(for _ <- 1..length, do: Enum.random(@numerics))
  end
end
