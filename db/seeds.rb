# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Location.create!([
  {
    name: 'Library 1',
    description: 'Coolest library ever'
  },
  {
    name: 'Library 2',
    description: 'Coolest library ever'
  },
  {
    name: 'Library 3',
    description: 'Coolest library ever'
  },
])

Nook.create!([
  {
    name: 'Nice office 1',
    location: Location.find(1),
    type: 'office'
  },
  {
    name: 'Nice office 2',
    location: Location.find(2),
    type: 'office'
  },
  {
    name: 'Nice office 3',
    location: Location.find(1),
    type: 'office'
  },
  {
    name: 'Nice office 4',
    location: Location.find(3),
    type: 'office'
  },
  {
    name: 'Nice office 5',
    location: Location.find(1),
    type: 'office'
  },
  {
    name: 'Nice office 6',
    location: Location.find(1),
    type: 'office'
  },
  {
    name: 'Nice office 7',
    location: Location.find(2),
    type: 'office'
  },
  {
    name: 'Nice office 8',
    location: Location.find(3),
    type: 'office'
  },
  {
    name: 'Nice office 9',
    location: Location.find(2),
    type: 'office'
  },
  {
    name: 'Nice office 10',
    location: Location.find(1),
    type: 'office'
  },
  {
    name: 'Nice office 11',
    location: Location.find(3),
    type: 'office'
  },
  {
    name: 'Nice office 12',
    location: Location.find(2),
    type: 'office'
  },
  {
    name: 'Nice office 13',
    location: Location.find(1),
    type: 'office'
  },
  {
    name: 'Nice office 14',
    location: Location.find(3),
    type: 'office'
  }
])

user = User.new(
                email: 'admin@example.com',
                password: '1234567890',
                password_confirmation: '1234567890',
                is_admin: true
  )
user.skip_confirmation!
user.save!
