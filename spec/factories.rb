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
    factory :game_with_invites do
      after(:create) do |game|
        game.users << create(:user)
      end
    end
    factory :game_with_invites_send do
      state = 'invites_send'
      after(:create) do |game|
        game.invite_player(create(:user))
      end
    end
    factory :finished_game do
      state "finished"
    end
  end
end
