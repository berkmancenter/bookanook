FactoryGirl.define do
  sequence :start_time do |n|
    d = (Time.now + 48.hours).next_week
    start_time = d.change(hour: 9) + (n % 8).hour
    if start_time < (d+1.day).change(hour:9) or start_time > d.change(hour: 16, min: 29)
      # puts start_time
      next_date = (d + (n % 7).days)
      if 0 < next_date.wday and next_date.wday < 6
        d = next_date
      else
        d = next_date.next_week
      end
      start_time = d.change(hour: 9) + (n % 7).hour
    # else
    #   puts start_time, "n", n
    end
    start_time
  end

  factory :nook do
    sequence(:name) { |n| "Nice nook #{n}" }
    description "It's a nice nook."
    location
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
    start_time
    end_time { start_time + 29.minutes}
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
