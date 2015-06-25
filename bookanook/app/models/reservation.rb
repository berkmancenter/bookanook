class Reservation < ActiveRecord::Base
  belongs_to :nook
  belongs_to :requester, class_name: 'User', foreign_key: 'user_id'

  module Status
    PENDING, REJECTED, CONFIRMED, CANCELED =
      'Awaiting review', 'Rejected', 'Confirmed', 'Canceled'
  end

  # From active_support/core_ext/numeric/time.rb
  REPEATABLE_UNITS = [
    'second', 'seconds',
    'minute', 'minutes',
    'hour', 'hours',
    'day', 'days',
    'week', 'weeks',
    'fortnight', 'fortnights',
  ]

  serialize :repeats_every

  validates_presence_of :start, :end
  validates_inclusion_of :status, in: Status.constants 
  validates_inclusion_of :public, in: [true, false]
  validates_numericality_of :priority, only_integer: true,
    greater_than_or_equal_to: 0

  after_initialize :set_defaults

  searchable do
    integer :nook_id
    string :status
    time :start
    time :end
  end

  private

  def set_defaults
    self.public ||= true if self.public.nil?
    self.status ||= Status::PENDING
    self.priority ||= 0
  end
end
