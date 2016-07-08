class Location < ActiveRecord::Base
  include ExtensibleAttrs
  include OpenAtHours
  resourcify

  has_many :nooks, dependent: :destroy
  has_many :reservations, through: :nooks

  after_initialize :set_defaults
  before_create :set_open_schedule

  acts_as_taggable_on :amenities

  reverse_geocoded_by :latitude, :longitude
  alias_attribute :lat, :latitude
  alias_attribute :lng, :longitude

  def admins
    User.with_role(:admin, self)
  end

  def set_geolocation(lat, lng)
    self.lat = lat.to_f
    self.lng = lng.to_f
  end


  def self.strip_location_data(locations)
    locations = locations.map do |location|
      [ location.id, location.name ].join(':')
    end
    locations.join(',')
  end

  private

  def set_defaults
    self.attrs ||= {}
    self.hidden_attrs ||= {}
  end

  def set_open_schedule
    return unless open_schedule.nil?
    schedule = create_open_schedule
    schedule.add_9_to_5
    schedule.save
  end
end
