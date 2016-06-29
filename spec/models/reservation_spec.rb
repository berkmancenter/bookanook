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
end
