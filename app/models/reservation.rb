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
  validates_inclusion_of :status, in: Status.constants.map{|s| Status.const_get(s)}
  validates_inclusion_of :public, in: [true, false]
  validates_numericality_of :priority, only_integer: true,
    greater_than_or_equal_to: 0
  validate :minimum_length, :maximum_length, :minimum_start, :maximum_start

  after_initialize :set_defaults

  def length
    self.end - self.start
  end
  alias :duration :length

  def self.confirmed
    where(status: Status::CONFIRMED)
  end

  def self.happening_now
    self.happening_at(Time.now)
  end

  def self.happening_at(time)
    confirmed.
      where('"reservations"."start" < :time AND "reservations"."end" > :time',
            { time: time })
  end

  private

  def set_defaults
    self.public ||= true if self.public.nil?
    self.priority ||= 0

    if nook && !nook.requires_approval
      self.status ||= Status::CONFIRMED
    else
      self.status ||= Status::PENDING
    end
  end

  def minimum_length
    if nook.min_reservation_length &&
      duration < nook.min_reservation_length.seconds
      errors.add(:end, "can't be less than " + 
                 "#{humanize_seconds(nook.min_reservation_length)} after start")
    end
  end

  def maximum_length
    if nook.max_reservation_length && 
      duration > nook.max_reservation_length.seconds
      errors.add(:end, "can't be more than " + 
                 "#{humanize_seconds(nook.max_reservation_length)} after start")
    end
  end

  def minimum_start
    if nook.min_schedulable && 
      self.start < Time.now + nook.min_schedulable.seconds
      errors.add(:start, "can't start less than " + 
                 "#{humanize_seconds(nook.min_schedulable)} from now")
    end
  end

  def maximum_start
    if nook.max_schedulable && 
      self.start > Time.now + nook.max_schedulable.seconds
      errors.add(:start, "can't start more than " + 
                 "#{humanize_seconds(nook.max_schedulable)} from now")
    end
  end

  def humanize_seconds
    [[60, :seconds], [60, :minutes], [24, :hours], [1000, :days]].map{ |count, name|
      if secs > 0
        secs, n = secs.divmod(count)
        "#{n.to_i} #{name}"
      end
    }.compact.reverse.join(' ')
  end
end
