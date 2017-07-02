require 'rails_helper'

RSpec.describe Reservation, type: :model do 
  before(:each) do
    @reservation = create(:reservation)
  end

  it "should be cancelable" do
    expect(@reservation.cancelable?).to eq(true)
  end

  it "should not be cancelable" do
    @reservation.start= 47.hours.from_now
    expect(@reservation.cancelable?).to eq(false)
  end

  it "should not allow overlapping reservation request" do
    overlap = create(:reservation, nook: @reservation.nook) #.new({title: "new Reservation"})
    overlap.start = @reservation.start + 10.minutes
    overlap.end = @reservation.end + 10.minutes
    overlap.valid?
    expect(overlap.errors[:nook_id]).to include("is not available for given time duration")
    overlap.start = @reservation.start + 30.minutes
    overlap.end = overlap.start + 29.minutes
    overlap.valid?
    expect(overlap.errors[:nook_id]).to_not include("is not available for given time duration")
  end
end
