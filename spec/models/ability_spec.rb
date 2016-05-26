require 'rails_helper'

RSpec.describe Ability, type: :model do
  describe 'Admin' do

    context 'on Location' do
      it 'can manage assciated location' do
        user = create(:user)
        location = create(:location)
        user.add_role :admin, location
        ability = Ability.new(user)
        expect( ability.can? :manage, location).to be_truthy
      end

      it 'cannot manage unassociated location' do
        user = create(:user)
        location1 = create(:location)
        location2 = create(:location)
        user.add_role :admin, location1
        ability = Ability.new(user)
        expect( ability.can? :manage, location1).to be_truthy
        expect( ability.can? :manage, location2).to be_falsey
      end

      it 'cannot destroy any location' do
        user = create(:user)
        location1 = create(:location)
        user.add_role :admin, location1
        ability = Ability.new(user)
        expect( ability.can? :destroy, location1).to be_falsey
      end
    end

    context 'on Nook' do
      it 'can manage nooks of associated location' do
        user = create(:user)
        nook = create(:nook)
        user.add_role :admin, nook.location
        ability = Ability.new(user)
        expect( ability.can? :manage, nook).to be_truthy 
      end

      it 'cannot manage nooks of unassociated location' do
        user = create(:user)
        location = create(:location)
        nook = create(:nook)
        user.add_role :admin, location
        ability = Ability.new(user)
        expect( ability.can? :manage, nook).to be_falsey
      end
    end

    context 'on Reservation' do
      it 'can manage reservation of associated nooks' do
        user = create(:user)
        reservation = create(:reservation)
        user.add_role :admin, reservation.nook.location
        ability = Ability.new(user)
        expect( ability.can? :manage, reservation).to be_truthy
      end

      it 'cannot manage reservation of unassociated nooks' do
        user = create(:user)
        reservation = create(:reservation)
        location = create(:location)
        user.add_role :admin, location
        ability = Ability.new(user)
        expect( ability.can? :manage, reservation).to be_falsey
      end
    end

  end

  describe 'Patron' do
    context 'on Location' do
      it 'have read only access to a location' do
        user = create(:user)
        ability = Ability.new(user)
        expect( ability.can? :read, Location).to be_truthy
      end

      it 'cannot create a location' do
        user = create(:user)
        ability = Ability.new(user)
        expect( ability.cannot? :create, Location).to be_truthy
      end

      it 'cannot update a location' do
        user = create(:user)
        location = create(:location)
        ability = Ability.new(user)
        expect( ability.cannot? :update, location).to be_truthy
      end

      it 'cannot destroy a location' do
        user = create(:user)
        location = create(:location)
        ability = Ability.new(user)
        expect( ability.cannot? :destroy, location).to be_truthy
      end
    end

    context 'on Nook' do
      it 'have read only access to a nook' do
        user = create(:user)
        ability = Ability.new(user)
        expect( ability.can? :read, Nook).to be_truthy
      end

      it 'cannot create a nook' do
        user = create(:user)
        ability = Ability.new(user)
        expect( ability.cannot? :create, Nook).to be_truthy
      end

      it 'cannot update a nook' do
        user = create(:user)
        nook = create(:nook)
        ability = Ability.new(user)
        expect( ability.cannot? :update, nook).to be_truthy
      end

      it 'cannot destroy a nook' do
        user = create(:user)
        nook = create(:nook)
        ability = Ability.new(user)
        expect( ability.cannot? :destroy, nook).to be_truthy
      end
    end

    context 'on Reservation' do
      it 'can manage associated reservations' do
        reservation = create(:reservation)
        ability = Ability.new(reservation.requester)
        expect( ability.can? :manage, reservation).to be_truthy
      end

      it 'cannot manage unassociated reservations' do
        reservation = create(:reservation)
        user = create(:user)
        ability = Ability.new(user)
        expect( ability.cannot? :manage, reservation).to be_truthy
      end

      it 'can read unowned public reservations' do
        reservation = create(:reservation)
        user = create(:user)
        ability = Ability.new(user)
        expect( ability.can? :read, reservation).to be_truthy
      end
    end
  end
end
