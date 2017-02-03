alias Playdays.Repo
alias Playdays.SecureRandom
alias Playdays.Consumer
alias Playdays.Queries.RegionQuery
alias Playdays.Queries.DistrictQuery

region = hd(RegionQuery.find_all)
district = hd(DistrictQuery.find_all)

for _ <- 1..250, do: %Consumer{} |> Consumer.changeset(%{
                                      name: Faker.Name.name,
                                      email: Faker.Internet.email,
                                      fb_user_id: SecureRandom.base64(16),
                                      devices: [
                                        %{
                                          uuid: SecureRandom.uuid,
                                          fb_access_token: SecureRandom.base64(16),
                                        }
                                      ],
                                      region_id: region.id,
                                      district_id: district.id,
                                      about_me: "about me description",
                                      children: [
                                        %{
                                          birthday: "2016-04"
                                        }
                                      ]
                                    })
                                    |> Repo.insert!
