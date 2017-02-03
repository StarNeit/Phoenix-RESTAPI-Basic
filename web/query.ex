defmodule Playdays.Query do

  @doc """

  Example use:

  # Chain queries and lazy load

  alias Playdays.Consumer
  import Playdays.Queries.ConsumerQuery

  consumers = Consumer
  |> scoped(%{email: "someone@example.com"})
  |> include(:consumer_identities)
  |> many

  # Single line fetch

  alias Playdays.Consumer
  import Playdays.Queries.ConsumerQuery

  find_one(Consumer, %{email: "someone@example.com"})

  OR

  alias Playdays.Queries.ConsumerQuery

  ConsumerQuery.find_one(%{email: "someone@example.com"})

  """

  import Ecto.Query

  alias Playdays.Repo

  defmacro __using__(opts) do
    quote do
      @model Keyword.get(unquote(opts), :model)

      if !@model do
        raise """
          opts :model is not found.
          Example use:

          defmodule Playdays.Queries.ConsumerQuery do
            import Ecto.Query

            use Playdays.Query, model: Playdays.Consumer

            ...
        """
      end

      @before_compile Playdays.Query
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def scoped(params), do: scoped(@model, params)
      def scoped(query, params) when is_map(params) do
        Enum.reduce(params, query, fn({key, value}, composed_query) ->
          composed_query
          |> where([c], field(c, ^key) == ^value)
        end)
      end

      def sort_by(query, expression) do
        query
        |> order_by(^expression)
      end

      def include(query, nil), do: query
      def include(query, asso) do
        query
        |> preload(^asso)
      end

      def find_one(params, opt \\ []), do: find_one(@model, params, opt)
      def find_one(query, params, opt) do
        query
        |> scoped(params)
        |> include(opt[:preload])
        |> one
      end

      def find_many(params, opt \\ []), do: find_many(@model, params, opt)
      def find_many(query, params, opt) do
        query
        |> scoped(params)
        |> include(opt[:preload])
        |> many
      end

      def find_all(opt \\ []) do
        @model
        |> include(opt[:preload])
        |> Repo.all
      end

      def one(query) do
        query
        |> Repo.one
      end

      def many(query, opt \\ []) do
        query
        |> include(opt[:preload])
        |> sort_by(opt[:sort_by])
        |> Repo.all
      end
    end
  end
end
