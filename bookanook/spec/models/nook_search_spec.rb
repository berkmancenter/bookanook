require 'rails_helper'

RSpec.describe NookSearch, type: :model do
  it "has default attributes" do
    search = NookSearch.new
    expect(search.methods).to include(:location_ids, :amenities,
                                      :nook_types, :time_range, :days)
  end

  describe '#has_default_params' do
    it "returns true if search initialized with no params" do
      search = NookSearch.new
      expect(search.has_default_params).to be_truthy
    end

    it "returns true if search initialized with no relevant params" do
      search = NookSearch.new(snorblat: 11)
      expect(search.has_default_params).to be_truthy
    end

    it "returns false if search initialized with relevant params" do
      search = NookSearch.new(location_ids: [13])
      expect(search.has_default_params).to be_falsey
    end
  end

  describe '#results' do
    context 'no nooks exist' do
      it 'returns zero nooks' do
        search = NookSearch.new
        expect(search.results).to be_empty
      end
    end

    context 'nooks exist' do
      before(:each) do
        Nook.remove_all_from_index!
        @nooks = create_list(:nook, 10)
        Sunspot.commit
      end

      it 'filters by location' do
        location_ids = Location.unscoped.pluck(:id).sample(3)
        search = NookSearch.new(location_ids: location_ids)
        expect(search.results).to match_array(Nook.where(location_id: location_ids))
      end

      it 'filters by amenities' do
        nook = create(:nook, amenities: ['snorlax'])
        Sunspot.commit

        search = NookSearch.new(amenities: ['snorlax'])
        expect(search.results.count).to eq(1)
        expect(search.results.first).to eq(nook)
      end

      it 'filters by type' do
        nooks = create_list(:nook, type: 'Study Room')
        Sunspot.commit

        search = NookSearch.new(nook_types: ['Study Room'])
        expect(search.results.count).to eq(1)
        expect(search.results.first).to eq(nook)
      end
      it 'filters by reservation time'
      it 'only finds bookable nooks'

      it 'returns relevant nooks if they exist' do
      end

      it 'returns zero nooks if no matching nooks exist' do
        search = NookSearch.new(amenities: ['smoking room'])
        expect(search.results).to be_empty
      end
    end
  end
end
