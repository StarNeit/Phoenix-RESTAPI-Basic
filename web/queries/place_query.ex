defmodule Playdays.Queries.PlaceQuery do
  import Ecto.Query

  use Playdays.Query, model: Playdays.Place

  def is_active(query) do
    query
      |> where([p], p.is_active == true)
  end
  
end
