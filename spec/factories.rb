FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  sequence :name do |n|
    "user#{n}"
  end

  sequence :title do |n|
    "title#{n}"
  end

  factory :user do
    email
    name
    password 'password'
  end

  factory :game do
    title
    description "Example game"
    factory :finished_game do
      state "finished"
    end
  end
end
