require 'carrierwave/orm/activerecord'

class Nook < ActiveRecord::Base
  belongs_to :location
  belongs_to :manager, class_name: 'User', foreign_key: 'user_id'
  has_many :reservations

  serialize :attrs, JSON
  serialize :hidden_attrs, JSON

  validates_presence_of :name, :location_id
  # schedulable and reservation_length are both in seconds
  validates_numericality_of :min_capacity, :min_schedulable,
    :min_reservation_length, greater_than_or_equal_to: 0
  validates_numericality_of :min_capacity, :max_capacity, only_integer: true
  validates_inclusion_of :bookable, :repeatable, :requires_approval,
    in: [true, false]

  after_initialize :set_defaults

  mount_uploaders :photos, PhotoUploader

  searchable do
    integer :id
    integer :location_id
    string :type
    string :amenities, multiple: true
    boolean :bookable
    join(:reservations_starting, target: Reservation, type: :time,
         join: { from: :nook_id, to: :id }, as: 'start_d')
  end

  private

  def set_defaults
    self.hours ||= {}
    self.min_capacity ||= 0
    self.min_schedulable ||= 0
    self.min_reservation_length ||= 0
    self.attrs ||= {}
    self.hidden_attrs ||= {}
    self.bookable ||= true if bookable.nil?
    self.repeatable ||= false if repeatable.nil?
  end

  def self.inheritance_column
    :sti_type
  end
end
