class Reservation < ActiveRecord::Base
  belongs_to :nook
  belongs_to :requester, class_name: 'User', foreign_key: 'user_id',
    inverse_of: :reservations

  delegate :email, to: :requester

  scope :is_public, -> { where(public: true) }
  scope :confirmed, -> { where(status: Reservation::Status::CONFIRMED) }
  scope :possible_conflict, ->(res=nil) { where.not(status: Reservation::Status::HIDEABLE, id: res) }

  acts_as_taggable_on :remarks

  before_save :ciel_end_time

  alias_attribute :start, :start_time
  alias_attribute :end, :end_time

  module Status
    PENDING, REJECTED, CONFIRMED, CANCELED =
      'Awaiting review', 'Rejected', 'Confirmed', 'Canceled'
    CANCELABLE = [PENDING, CONFIRMED]
    MODIFIABLE = [PENDING]
    HIDEABLE = [REJECTED, CANCELED]
  end

  STATUSES = Status.constants.map{|s| Status.const_get(s)}.flatten.uniq

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

  validates_presence_of :name, :start_time, :end_time, :nook, :requester, :no_of_people
  validates_inclusion_of :status, in: STATUSES
  validates_inclusion_of :public, in: [true, false]
  validates_numericality_of :priority, only_integer: true,
    greater_than_or_equal_to: 0
  validate :available
  validates_numericality_of :no_of_people, only_integer: true,
    greater_than: 0

  validate :minimum_length, :maximum_length, :people_validation

  after_initialize :set_defaults

  def time_range
    if start && self.end
      (start.hour * 100 + start.min)...(self.end.hour * 100 + self.end.min)
    end
  end

  def requester_id
    user_id
  end

  def length
    self.end - self.start + 1.second
  end
  alias :duration :length

  def cancel
    self.status = Status::CANCELED
  end

  def confirm
    self.status = Status::CONFIRMED
  end

  def reject
    self.status = Status::REJECTED
  end

  def pending_review?
    status == Status::PENDING
  end

  def confirmed?
    status == Status::CONFIRMED
  end

  def cancelable?
    (Status::CANCELABLE.include? status) && ((self.start.to_i-Time.now.to_i) > (self.nook.modifiable_before*3600))
  end

  def modifiable?
    (Status::MODIFIABLE.include? status) && ((self.start.to_i-Time.now.to_i) > (self.nook.modifiable_before*3600))
  end

  def available
    errors.add(:nook_id, "is not available for given time duration") unless self.nook.available_for?(self.start_time..self.end_time,self)
  end

  def self.confirmed(reservations=nil)
    return where(status: Status::CONFIRMED) if reservations.nil?
    reservations.where(status: Status::CONFIRMED)
  end

  def self.happening_now
    happening_at(Time.now)
  end

  def self.happening_at(time)
    confirmed.
      where('"reservations"."start_time" < :time AND "reservations"."end_time" > :time',
            { time: time })
  end

  def self.happening_within(time_range, reservations=nil)
    reservations = Reservation.all if reservations.nil?
    reservations.confirmed.where('tsrange("reservations"."start_time", "reservations"."end_time") <@ ' +
                    'tsrange(?, ?)', time_range.begin, time_range.end)
  end

  def self.overlapping_with(time_range,res=nil)
    possible_conflict(res).where('tsrange("reservations"."start_time", "reservations"."end_time") && ' +
                    'tsrange(?, ?)', time_range.begin, time_range.end)
  end

  # Used in downloadable statistics report
  def self.to_csv(reservations, options = {})
    CSV.generate(options) do |csv|
      csv << [ 'Location', 'Nook name', 'Id', 'Name', 'Description', 'No. of People', 'Start', 'End', 'Created at' ]
      reservations.each do |reservation|
        csv << [ reservation.nook.location.name,
                 reservation.nook.name,
                 reservation.attributes.values_at('id', 'name', 'description', 'no_of_people', 'start_time', 'end_time', 'created_at') ].flatten
      end
    end
  end

  # Remind users whose reservations are scheduled on 'date'
  def self.send_reminders(date)
    reservations = Reservation.happening_within(date.beginning_of_day..date.end_of_day)
    for reservation in reservations
      UserMailer.reservation_reminder(reservation.requester, reservation).deliver
    end
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
    if nook && nook.min_reservation_length &&
      duration < nook.min_reservation_length.seconds
      errors.add(:end_time, "can't be less than " +
                 "#{Reservation.humanize_seconds(nook.min_reservation_length)} after start")
    end
  end

  def maximum_length
    if nook && nook.max_reservation_length &&
      duration > nook.max_reservation_length.seconds
      errors.add(:end_time, "can't be more than " +
                 "#{Reservation.humanize_seconds(nook.max_reservation_length)} after start")
    end
  end

  # replaced by reservable_before_hours
  def minimum_start
    if nook && nook.min_schedulable &&
      self.start < Time.now + nook.min_schedulable.seconds
      errors.add(:start_time, "can't start less than " +
                 "#{Reservation.humanize_seconds(nook.min_schedulable)} from now")
    end
  end

  # replaced by unreservable_before_days
  def maximum_start
    if nook && nook.max_schedulable &&
      self.start > Time.now + nook.max_schedulable.seconds
      errors.add(:start_time, "can't start more than " +
                 "#{Reservation.humanize_seconds(nook.max_schedulable)} from now")
    end
  end

  def people_validation
    if no_of_people.present?
      unless (nook.min_capacity.present? && nook.min_capacity <= no_of_people) ||
        (nook.max_capacity.present? && no_of_people <= nook.max_capacity)      ||
        ((nook.min_capacity.present? && nook.min_capacity <= no_of_people) &&
          (nook.max_capacity.present? && no_of_people <= nook.max_capacity))
        errors.add(:no_of_people, "is not within range permitted for booking")
      end
    end
  end

  def self.humanize_seconds(secs)
    return '0 hours' if secs == 0
    [[60, :seconds], [60, :minutes], [24, :hours], [1000, :days]].map{ |count, name|
      if secs > 0
        secs, n = secs.divmod(count)
        "#{n.to_i} #{name}" unless name == :seconds
      end
    }.compact.reverse.join(' ')
  end

  def ceil_time(time, seconds=60)
    Time.at((time.to_f / seconds).ceil * seconds)
  end

  # ceil to nearest half-hour
  def ciel_end_time
    self.end = ceil_time(self.end, 30.minutes) - 1.seconds
  end
end
