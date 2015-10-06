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
        @nooks = create_list(:nook, 10)
      end

      it 'filters by location' do
        location_ids = Location.unscoped.pluck(:id).sample(3)
        search = NookSearch.new(location_ids: location_ids)
        expect(search.results).to match_array(Nook.where(location_id: location_ids))
      end

      it 'filters by amenities' do
        nook = create(:nook, amenities: ['snorlax'])
        search = NookSearch.new(amenities: ['snorlax'])
        expect(search.results.count).to eq(1)
        expect(search.results.first).to eq(nook)
      end

      it 'filters by type' do
        nooks = create_list(:nook, 3, type: 'Study Room')
        search = NookSearch.new(nook_types: ['Study Room'])
        expect(search.results.count).to eq(3)
        expect(search.results).to match_array(nooks)
      end

      it 'filters by reservable time' do
        search_days = [Date.tomorrow]
        search_start = Time.now.seconds_since_midnight
        search_end = search_start + 2.hours
        search_time_range = { start: search_start, end: search_end }

        nook = create(:nook)
        create(:confirmed_reservation, nook: nook,
               start: search_days.first.to_time + search_start.seconds,
               end: search_days.first.to_time + search_end.seconds)

        search = NookSearch.new(days: search_days, time_range: search_time_range)
        expect(search.results.count).to be > 0
        expect(search.results.collect(&:id)).not_to include(nook.id)
      end

      it 'filters by reservable time available for any day', wip: true do
        search_days = [Date.tomorrow, Date.today + 2.days]
        search_start = Time.now.seconds_since_midnight
        search_end = search_start + 2.hours
        search_time_range = { start: search_start, end: search_end }

        nook = create(:nook)
        create(:confirmed_reservation, nook: nook,
               start: search_days.first.to_time + search_start.seconds,
               end: search_days.first.to_time + search_end.seconds)

        search = NookSearch.new(days: search_days, time_range: search_time_range)
        expect(search.results).to include(nook)
      end

      it 'only finds bookable nooks' do
        create(:nook, amenities: ['snorlax'], bookable: false)
        search = NookSearch.new(amenities: ['snorlax'])
        expect(search.results.count).to eq(0)
      end

      it 'only finds open nooks' do
        nook = create(:nook, amenities: ['snorlax'])
        nook.open_schedule = OpenSchedule.new # default is always closed
        nook.save
        search = NookSearch.new(amenities: ['snorlax'])
        expect(search.results.count).to eq(0)
      end

      it 'returns zero nooks if no matching nooks exist' do
        search = NookSearch.new(amenities: ['smoking room'])
        expect(search.results).to be_empty
      end
    end
  end
end
