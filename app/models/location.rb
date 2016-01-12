class Location < ActiveRecord::Base
  include ExtensibleAttrs
  include OpenAtHours

  has_many :nooks
  has_many :reservations, through: :nooks

  after_initialize :set_defaults
  before_create :set_open_schedule

  acts_as_taggable_on :amenities

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
