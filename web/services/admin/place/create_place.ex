defmodule Playdays.Services.Admin.Place.CreatePlace do

  alias Playdays.Repo
  alias Playdays.Place
  alias Playdays.Queries.CategoryQuery
  alias Playdays.Queries.TagQuery
  alias Playdays.Queries.DistrictQuery

  def call(params) do
    place_changeset = %Place{} |> Place.changeset(params)
    if params[:selected_categories_id] do
      categories_changeset = params[:selected_categories_id]
                              |> Enum.map(fn(id) ->
                                  CategoryQuery.find_one(%{id: id})
                                    |> Ecto.Changeset.change
                                 end)

      place_changeset = place_changeset |> Ecto.Changeset.put_assoc(:categories, categories_changeset)
    end

    if params[:selected_tags_id] do
      tags_changeset = params[:selected_tags_id]
                        |> Enum.map(fn(id) ->
                            TagQuery.find_one(%{id: id})
                              |> Ecto.Changeset.change
                           end)

      place_changeset = place_changeset |> Ecto.Changeset.put_assoc(:tags, tags_changeset)
    end

    if params[:selected_districts_id] do
      districts_changeset = params[:selected_districts_id]
                            |> Enum.map(fn(id) ->
                                DistrictQuery.find_one(%{id: id})
                                  |> Ecto.Changeset.change
                               end)

      place_changeset = place_changeset |> Ecto.Changeset.put_assoc(:districts, districts_changeset)
    end

    place_changeset
      |> Repo.insert
  end
end
