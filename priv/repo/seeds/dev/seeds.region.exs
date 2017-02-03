alias Playdays.Repo
alias Playdays.Region
alias Playdays.District


[
  %{ path: "regions.default.json" }
]
  |> Enum.each(fn(%{path: path}) ->
      path
      |> Path.absname("./priv/repo/seeds/#{Mix.env}/region")
      |> Path.expand
      |> File.read!
      |> Poison.decode!
      |> Enum.each(fn(region) ->
        inserted_region = %Region{}
                  |> Region.changeset(%{
                        name: region["name"],
                        hex_color_code: region["hex_color_code"],
                     })
                  |> Repo.insert!
        region["districts"] |> Enum.each(fn(district) ->
          %District{}
            |> District.changeset(%{
                name: district["name"],
                hex_color_code: district["hex_color_code"],
                region_id: inserted_region.id
              })
            |> Repo.insert!
        end)
      end)
    end)
