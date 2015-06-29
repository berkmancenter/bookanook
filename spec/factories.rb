FactoryGirl.define do
  factory :nook do
    sequence(:name, 'Nook 1')
    description "It's a nice nook."
    location
    amenities ['movable furniture', 'projector']
    bookable true
    manager
  end

  factory :location do
    sequence(:name, 'Library 1')
    description "It's a library"
    amenities ['movable furniture', 'projector', 'conference phone']
  end

  factory :user do
    sequence(:email) { |n| "jclark+#{n}@cyber.law.harvard.edu" }
    password 'password'
    password_confirmation 'password'

    factory :confirmed_user do
      after(:create) { |user| user.confirm! }

      factory :manager do
      end
    end
  end

  factory :reservation do
    nook
    association :requester, factory: :confirmed_user
    add_attribute('public', true)
    start Time.now
    add_attribute('end', 1.hour.from_now)
  end

  factory :nook_search do
    skip_create
  end
end
