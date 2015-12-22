require 'rails_helper'

RSpec.describe Nook, type: :model do
  describe 'default attributes' do
    before(:each) do
      @nook = create(:nook)
    end

    it 'has basic attributes' do
      expect(@nook).to respond_to(
        :name, :description, :type, :place,
        :min_capacity, :max_capacity,
        :min_schedulable, :max_schedulable,
        :min_reservation_length, :max_reservation_length,
        :photos, :amenities, :use_policy,
        :bookable, :requires_approval, :repeatable
      )
    end

    it 'has ExtensibleAttributes' do
      expect(@nook).to respond_to( :attrs, :hidden_attrs )
    end

    it 'has open_schedule' do
      expect(@nook).to respond_to :open_schedule
    end

    it 'has a location' do
      expect(@nook).to respond_to :location
    end

    it 'has a manager' do
      expect(@nook).to respond_to :manager
    end

    it 'has reservations' do
      expect(@nook).to respond_to :reservations
    end
  end

  describe '#set_defaults' do
    it 'sets ExtensibleAttributes defaults' do
      nook = Nook.new
      expect(nook.attrs).to eq( { } )
      expect(nook.hidden_attrs).to eq( { } )
    end
  end

  describe '#amenity_list' do
    it 'can be an array' do
      nook = Nook.new amenity_list: [ 'projector', 'conference phone' ]
      expect( nook.amenity_list.count ).to eq( 2 )
    end
  end

  describe '#location' do
    FactoryGirl.create :nook
    nook = Nook.last

    it 'has a location' do
      expect( nook.location ).to be_present
    end
  end

  describe '#manager' do
    it 'has a manager' do
      nook = create(:nook)
      expect( nook.manager ).to be_present
    end
  end

  describe '#reservations' do
    it 'has a reservation' do
      nook = create(:nook)
      create(:reservation, nook: nook)
      expect( nook.reservations.count ).to eq( 1 )
    end
  end
end
