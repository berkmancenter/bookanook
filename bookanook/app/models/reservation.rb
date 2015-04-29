class Reservation < ActiveRecord::Base
  belongs_to :nook
  belongs_to :requester
end
