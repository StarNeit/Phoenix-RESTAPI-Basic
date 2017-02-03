defmodule Playdays.Queries.MemberQuery do
  import Ecto.Query

  alias Playdays.Member
  alias Playdays.FriendRelationship
  alias Playdays.Repo

  use Playdays.Query, model: Member

  def search(params), do: search(Playdays.Member, params)

  def search(query, %{fname: fname, lname: lname}) do
    query
      |> where([m], fragment("? % ?", m.fname, ^fname) or fragment("? % ?", m.lname, ^lname) or ilike(m.fname, ^"%#{fname}%") or ilike(m.lname, ^"%#{lname}%"))
      |> many
  end

  def where_id_in(query \\ Member, ids) do
    query
    |> where([m], m.id in ^ids)
    |> many
  end

  #def with_friends(Member) do
  #  friends = from m in Member, order_by: c.name, preload: [:region, :district]
  #  consumer
  #  |> Repo.preload([friends: friends])
  #end

  #def count_friend(id) when is_integer(id) do
  #  FriendRelationship
  #  |> where([r], ^id == r.consumer_0_id)
  #  |> select([r], count(r.id))
  #  |> Repo.one
  #end

end
