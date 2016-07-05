require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  before(:each) do
    FactoryGirl.create :user
  end

  it "should deliver mail containing password" do
    expect { UserMailer.send_password(User.last).deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
