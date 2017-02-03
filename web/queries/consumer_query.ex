defmodule Playdays.Queries.ConsumerQuery do
  import Ecto.Query

  alias Playdays.Consumer
  alias Playdays.FriendRelationship
  alias Playdays.Repo

  use Playdays.Query, model: Consumer

  def search(params), do: search(Playdays.Consumer, params)

  def search(query, %{name: name}) do
    query
      |> where([c], fragment("? % ?", c.name, ^name) or ilike(c.name, ^"%#{name}%"))
      |> many
  end

  def where_id_in(query \\ Consumer, ids) do
    query
    |> where([c], c.id in ^ids)
    |> many
  end

  def with_friends(consumer) do
    friends = from c in Consumer, order_by: c.name, preload: [:region, :district]
    consumer
    |> Repo.preload([friends: friends])
  end

  def count_friend(id) when is_integer(id) do
    FriendRelationship
    |> where([r], ^id == r.consumer_0_id)
    |> select([r], count(r.id))
    |> Repo.one
  end

end
