FactoryBot.define do
  factory(:restaurant) do
    name { "Sam's Grill & Seafood Restaurant" }
    hours do
      {
        "friday"=>{"open"=>"1130", "closed"=>"2100"},
        "monday"=>{"open"=>"1130", "closed"=>"2100"},
        "sunday"=>{"open"=>"1130", "closed"=>"2100"},
        "tuesday"=>{"open"=>"1130", "closed"=>"2100"},
        "saturday"=>{"open"=>"1130", "closed"=>"2100"},
        "thursday"=>{"open"=>"1130", "closed"=>"2100"},
        "wednesday"=>{"open"=>"1130", "closed"=>"2100"}
      }
    end

    trait(:randomly_named) do
      name { Faker::Restaurant.name }
    end

    trait(:closed_on_sunday) do
      hours do
        {
          "friday"=>{"open"=>"1100", "closed"=>"2100"},
          "monday"=>{"open"=>"1100", "closed"=>"2100"},
          "sunday"=>{"open"=>nil, "closed"=>nil},
          "tuesday"=>{"open"=>"1100", "closed"=>"2100"},
          "saturday"=>{"open"=>"1700", "closed"=>"2100"},
          "thursday"=>{"open"=>"1100", "closed"=>"2100"},
          "wednesday"=>{"open"=>"1100", "closed"=>"2100"}
        }
      end
    end
  end
end
