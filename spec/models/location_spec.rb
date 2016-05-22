require 'rails_helper'

RSpec.describe Location, type: :model do
  describe 'default attributes' do
    location = Location.new

    it 'has basic attributes' do
      expect(location.methods).to include(:name, :description, :amenities)
    end

    it 'has ExtensibleAttributes' do
      expect(location.methods).to include(:attrs, :hidden_attrs)
    end

    it 'has open_schedule' do
      expect(location).to respond_to :open_schedule
    end

    it 'has nooks and reservations' do
      expect(location).to respond_to :nooks, :reservations
    end
  end

  describe '#set_defaults' do
    it 'sets ExtensibleAttributes defaults' do
      location = Location.new
      expect(location.attrs).to eq( { } )
      expect(location.hidden_attrs).to eq( { } )
    end
  end

  describe '#amenities' do
    it 'can be an array' do
      location = Location.new amenities: [ 'projector', 'conference phone' ]
      expect( location.amenities.count ).to eq( 2 )
    end

    it 'saves and refreshes as an array' do
      FactoryGirl.create :location
      #Location.create amenities: [ 'Projector', 'Conference Phone' ]
      location = Location.last
      expect( location.amenities.count ).to eq( FactoryGirl.attributes_for( :location )[ :amenities ].count )
    end
  end

  describe '#nooks' do
    it 'has a nook' do
      location = create(:location)
      create(:nook, location: location)
      expect( location.nooks.count ).to eq( 1 )
    end
  end

  describe '#reservations' do
    it 'has a reservation' do
      location = create(:location)
      create(:reservation, nook: create(:nook, location: location))
      expect( location.reservations.count ).to eq( 1 )
    end
  end
end
