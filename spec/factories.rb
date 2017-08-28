FactoryGirl.define do
  factory :nook do
    sequence(:name, 'Nook 1')
    description "It's a nice nook."
    location
    min_capacity 2
    bookable true
  end

  factory :location do
    sequence(:name, 'Library 1')
    description "It's a library"
    amenity_list [ 'Projector', 'Conference Phone' ]

    factory :location_with_hours do
      after(:build) { |location| location.build_open_schedule.add_9_to_5 }
    end
  end

  factory :user do
    sequence(:email) { |n| "jclark+#{n}@cyber.law.harvard.edu" }
    password 'password'
    password_confirmation 'password'

    factory :confirmed_user do
      after(:create) { |user| user.confirm }
    end

    factory :admin do
      after(:create) { |user|
        user.confirm
        user.add_role :admin
        user.save
      }
    end
  end

  factory :reservation do
    nook
    sequence(:name) { |n| "Test Reservation #{n}" }
    association :requester, factory: :confirmed_user
    add_attribute('public', true)
    start 49.hour.from_now
    add_attribute('end', 50.hour.from_now)
    add_attribute('no_of_people', 2)
    factory :confirmed_reservation do
      status Reservation::Status::CONFIRMED
    end
  end

  factory :nook_search do
    skip_create
  end

  factory :open_schedule do
    sequence(:name) { |n| "Test Schedule #{n}" }
    start Date.today.at_beginning_of_day
    duration 4.hours
    seconds_per_block 60 * 15
    blocks_per_span 8
  end
end
