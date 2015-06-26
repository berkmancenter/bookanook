require 'carrierwave/orm/activerecord'

class Nook < ActiveRecord::Base
  include ExtensibleAttrs
  include OpenAtHours

  belongs_to :location
  belongs_to :manager, class_name: 'User', foreign_key: 'user_id'
  has_many :reservations

  validates_presence_of :name, :location_id
  # schedulable and reservation_length are both in seconds
  validates_numericality_of :min_capacity, :min_schedulable,
    :min_reservation_length, greater_than_or_equal_to: 0, allow_blank: true
  validates_numericality_of :min_capacity, :max_capacity, only_integer: true,
    allow_blank: true
  validates_inclusion_of :bookable, :repeatable, :requires_approval,
    in: [true, false]

  after_initialize :set_defaults

  mount_uploaders :photos, PhotoUploader

  def available_now?
    location.open_now? && open_now? && bookable &&
      reservations.happening_now.empty?
  end

  private

  def set_defaults
    self.attrs ||= {}
    self.hidden_attrs ||= {}
    self.bookable ||= true if bookable.nil?
    self.requires_approval ||= true if requires_approval.nil?
    self.repeatable ||= false if repeatable.nil?
    self.open_schedule ||= location.open_schedule if location
  end

  def self.inheritance_column
    :sti_type
  end
end
