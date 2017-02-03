import Ecto.Query
alias Playdays.Repo
alias Playdays.Event


[
  %{ path: "events.default.json" }
]
  |> Enum.each(fn(%{path: path}) ->
      path
      |> Path.absname("./priv/repo/seeds/#{Mix.env}/event")
      |> Path.expand
      |> File.read!
      |> Poison.decode!
      |> Enum.each(fn(event) ->
        %Event{}
          |> Event.changeset(%{
                name: event["name"],
                location_address: event["location_address"],
                website_url: event["website_url"],
                description: event["description"],
                contact_number: event["contact_number"],
                price_range: %{lo: event["price_range"]["lo"], hi: event["price_range"]["hi"]},
                lat: Faker.format("22.3231###"),
                long: Faker.format("114.1677###"),
                joined_consumer_number: 0,
                booking_url: event["booking_url"],
                booking_hotline: event["booking_hotline"],
                number_of_likes: 0,
                time_slots: [
                  %{
                    date: 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now),
                    from: 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now),
                    to: 1000 * Timex.DateTime.to_seconds(Timex.DateTime.now)
                  }
                ]
              })
        |> Repo.insert!
      end)
    end)
