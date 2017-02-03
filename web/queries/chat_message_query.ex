defmodule Playdays.Queries.ChatMessageQuery do
  import Ecto.Query

  alias Playdays.Repo
  use Playdays.Query, model: Playdays.ChatMessage
end
