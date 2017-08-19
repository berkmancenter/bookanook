require 'carrierwave/orm/activerecord'

class Nook < ActiveRecord::Base
  include ExtensibleAttrs
  include OpenAtHours

  belongs_to :location
  has_many :reservations, dependent: :destroy

  delegate :name, :attrs, to: :location, prefix: true, allow_nil: true

  acts_as_taggable_on :amenities

  validates_presence_of :name, :location_id
  # schedulable and reservation_length are both in seconds
  validates_numericality_of :min_capacity, :min_schedulable,
    :min_reservation_length, greater_than_or_equal_to: 0, allow_blank: true
  validates_numericality_of :min_capacity, :max_capacity, only_integer: true,
    allow_blank: true
  validates_inclusion_of :bookable, :repeatable, :requires_approval,
    in: [true, false]

  before_validation :set_defaults
  after_initialize :set_defaults

  mount_uploaders :photos, PhotoUploader

  STATUSES = [ :available, :unavailable ]

  # CarrierWave is throwing errors without it
  skip_callback :commit, :after, :remove_previously_stored_photos

  def available_now?
    available_at? Time.now
  end

  def available_at?(time)
    available = bookable && reservations.happening_at(time).empty?
    available &&= location.open_at?(time) if location.open_schedule
    available &&= open_at?(time) if open_schedule
    available
  end

  def available_for?(time_range)
    available = bookable && reservations.overlapping_with(time_range).empty?
    available &&= location.open_for_range?(time_range) if location.open_schedule
    available &&= open_for_range?(time_range) if open_schedule
    available # I don't think this line is necessary, but not sure yet.
  end

  # used in blocking reserved slots on reservation form or expanded-nook view
  def reserved_slots(date)
    Reservation.confirmed.where(nook_id: self.id)
                          .happening_within(date.in_time_zone.beginning_of_day..date.in_time_zone.end_of_day)
                          .map do |r|
                            r.start.strftime('%H%M').to_i..
                            (r.end + 1.seconds).strftime('%H%M').to_i
                          end
  end

  def remove_photo(photo_id)
    remain_photos = self.photos # copy the array
    deleted_photo = remain_photos.delete_at(photo_id.to_i) # delete the target photo
    deleted_photo.try(:remove!) # delete photo from S3
    self.photos = remain_photos # re-assign back
    self.remove_photos! if remain_photos.empty?
    if self.save
      return true
    else
      return false
    end
  end
  # Used in initializing selectize options
  def self.strip_nook_data(nooks)
    nooks = nooks.map do |nook|
      [ nook.id, nook.name ].join(':')
    end
    nooks.join(',')
  end

  private

  def set_defaults
    self.attrs ||= {}
    self.hidden_attrs ||= {}
    self.bookable ||= true if bookable.nil?
    self.requires_approval ||= true if requires_approval.nil?
    self.repeatable ||= false if repeatable.nil?
    self.open_schedule ||= location.open_schedule.dup if location
  end

  def self.inheritance_column
    :sti_type
  end
end
