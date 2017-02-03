alias Playdays.Repo
alias Playdays.Place

for _ <- 1..250, do: %Place{} |> Place.changeset(%{
                                    name: "#{Faker.Company.name} #{Faker.Company.bullshit}",
                                    website_url: Faker.Internet.domain_name,
                                    contact_number: "+85298881111",
                                    location_address: Faker.Address.street_address,
                                    description: Faker.Lorem.paragraphs(5) |> Enum.join,
                                    categories: [],
                                    tags: [],
                                    lat: Faker.format("22.3231###"),
                                    long: Faker.format("114.1677###"),
                                    image: "https://upload.wikimedia.org/wikipedia/commons/a/a1/2009-04-21_Hampton_Forest_Apartment_Homes_playground.jpg"
                                  })
                                |> Repo.insert!
