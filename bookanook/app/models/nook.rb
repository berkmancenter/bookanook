class Nook < ActiveRecord::Base
  belongs_to :location
  belongs_to :manager
end
