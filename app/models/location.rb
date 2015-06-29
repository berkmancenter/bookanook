class Location < ActiveRecord::Base
  include ExtensibleAttrs
  include OpenAtHours

  has_many :nooks
  has_many :reservations, through: :nooks

  after_initialize :set_defaults

  private
  
  def set_defaults
    self.attrs ||= {}
    self.hidden_attrs ||= {}
    self.open_schedule ||= build_open_schedule
  end
end
