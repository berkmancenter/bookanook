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
      user = create :admin
      sign_in user
      get admin_root_url
      assert_equal 200, status
      expect(response.body).to include(cookies["browser.timezone"])
    end

    it "should display available bookable slots in user timezone" do
      user = create :confirmed_user
      sign_in user
      @nook = create :nook
      xhr :get, reserve_nook_url(@nook), search_date: Date.today
      time_at_10 = Time.zone.parse("10:00").in_time_zone(cookies["browser.timezone"])
      time_at_530 = Time.zone.parse("5:30").in_time_zone(cookies["browser.timezone"])
      if time_at_10.min == 0
        expect(response.body).to include('<button class="btn open" type="button" value="' + time_at_10.strftime("%H%M") + '"></button>')
      else
        expect(response.body).to include('<button class="btn open right" type="button" value="' + time_at_10.strftime("%H%M") + '"></button>')
      end
      expect(response.body).to include('<button class="btn taken" disabled="true" type="button" value="' + time_at_530.strftime("%H%M") + '"></button>')
    end

  end
end
