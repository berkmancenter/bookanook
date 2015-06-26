require 'carrierwave/orm/activerecord'

class Nook < ActiveRecord::Base
  belongs_to :location
  belongs_to :manager, class_name: 'User', foreign_key: 'user_id'
  has_many :reservations

  serialize :hours
  serialize :attrs
  serialize :hidden_attrs

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

  def open
    return true if hours.nil? || hours.empty?
  end

  def available_now?
    open && bookable && reservations.happening_now.empty?
  end

  def next_available
  end

  private

  def set_defaults
    self.hours ||= {}
    self.attrs ||= {}
    self.hidden_attrs ||= {}
    self.bookable ||= true if bookable.nil?
    self.requires_approval ||= true if requires_approval.nil?
    self.repeatable ||= false if repeatable.nil?
  end

  def self.inheritance_column
    :sti_type
  end
end
