require 'carrierwave/orm/activerecord'

class Nook < ActiveRecord::Base
  belongs_to :location
  belongs_to :manager, class_name: 'User', foreign_key: 'user_id'
  has_many :reservations

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

  def status
    'Available'
  end

  private

  def self.inheritance_column
    :sti_type
  end
end
