require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'roles' do
    it 'can assume admin role' do
      FactoryGirl.create :user
      user = User.last
      user.add_role :admin
      expect( user.has_role? :admin ).to be_truthy
    end

    it 'can assume superadmin role' do
      FactoryGirl.create :user
      user = User.last
      user.add_role :superadmin
      expect( user.has_role? :superadmin ).to be_truthy
    end

    it 'can be admin of a location' do
      FactoryGirl.create :user
      FactoryGirl.create :location
      location1 = Location.last
      user = User.last
      user.add_role :admin, location1
      expect( user.has_role? :admin, location1 ).to be_truthy
    end

    it 'is not an admin of a location by default' do
      FactoryGirl.create :user
      FactoryGirl.create :location
      location1 = Location.last
      FactoryGirl.create :location
      location2 = Location.last
      user = User.last
      user.add_role :admin, location1
      expect( user.has_role? :admin, location1 ).to be_truthy
      expect( user.has_role? :admin, location2 ).to be_falsey
    end
  end
end
