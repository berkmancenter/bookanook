require 'rails_helper'

describe OpenSchedule do
  describe '#add_open_range' do
    it 'marks all the blocks in the given range as open'
  end

  describe '#open_at?' do
    it 'returns the same value for different multiples of time'
  end

  describe '#open_for_range?' do
    it 'returns correctly when the range straddles the end of the schedule period' do
    end
  end

  describe '#add_9_to_5' do
    it 'marks all weekday blocks between 9am and 5pm local time as open' do
      schedule = OpenSchedule.new
      schedule.add_9_to_5
      (1..5).each do |i|
        opening = OpenSchedule::A_SUNDAY_AT_LOCAL_MIDNIGHT + i.day + 9.hours
        closing = opening + 8.hours
        expect(schedule.open_for_range?(opening..closing)).to be_truthy
      end
    end

    it 'does not mark any blocks on Saturday or Sunday as open' do
      schedule = OpenSchedule.new
      schedule.add_9_to_5
      sunday_midnight = OpenSchedule::A_SUNDAY_AT_LOCAL_MIDNIGHT
      sat = (sunday_midnight - 1.day)..sunday_midnight
      sun = sunday_midnight..(sunday_midnight + 24.hours)
      puts sat.inspect
      expect(schedule.closed_for_range?(sat)).to be_truthy
      expect(schedule.closed_for_range?(sun)).to be_truthy
    end
  end
end
