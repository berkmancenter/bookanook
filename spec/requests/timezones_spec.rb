require 'rails_helper'
RSpec.describe "Timezone Set", type: :request do
  describe "GET / and /admin" do
    before { cookies["browser.timezone"] = "Asia/Kolkata" }

    it "should correctly set user timezone" do
      get root_url
      assert_equal 200, status
      expect(response.body).to include(cookies["browser.timezone"])
    end

    it "should correctly set admin timezone" do
      FactoryGirl.create :user
      user = User.last
      user.add_role :admin
      user.confirmed_at = Time.zone.now
      user.save
      sign_in user
      get admin_root_url
      assert_equal 200, status
      expect(response.body).to include(cookies["browser.timezone"])
    end
  end
end
