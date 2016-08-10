FactoryGirl.define do
  factory :todo do
    title { Faker::Lorem.word }
    body { Faker::Lorem.sentence }
    status "Pending"
    created_at Time.now.to_s
  end
end
