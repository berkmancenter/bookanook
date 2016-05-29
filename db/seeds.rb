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

users = [ "superadmin", "admin1", "admin2", "admin3", "patron" ]

users.each do |role|
  user = User.new( :email => "#{role}@bookanook.com",
                   :password => '12345678',
                   :password_confirmation => '12345678' )
  user.skip_confirmation!
  user.save!
end

User.find(1).add_role :superadmin
User.find(2).add_role :admin, Location.find(1)
User.find(2).add_role :admin, Location.find(2)
User.find(3).add_role :admin, Location.find(3)
User.find(4).add_role :admin, Location.find(1)
