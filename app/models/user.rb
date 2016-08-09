class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, omniauth_providers: [ :google_oauth2 ]

  STATUSES = [ :active, :banned ]
  PERMISSIBLE_SLOTS = 4 # can request for atmost 2 hours per day i.e. 4 half hours

  has_many :reservations
  has_many :notifications

  def admin?
    return has_role? :admin, :any
  end

  def superadmin?
    return has_role? :superadmin
  end

  def generate_password
    ((1..9).to_a + ('a'..'z').to_a + ('A'..'Z').to_a).shuffle[0, 12].join
  end

  def locations_in_charge(locations=nil)
    return Location.all if superadmin?
    return locations.with_roles( :admin, self ) unless locations.nil?
    Location.with_roles( :admin, self )
  end

  def nooks_in_charge(nooks=nil)
    return Nook.all if superadmin?
    return nooks.where(location_id: locations_in_charge.ids) unless nooks.nil?
    Nook.where(location_id: locations_in_charge.ids)
  end

  def reservations_in_charge(reservations=nil)
    return Reservation.all if superadmin?
    return reservations.where(nook_id: nooks_in_charge.ids) unless reservations.nil?
    Reservation.where(nook_id: nooks_in_charge.ids)
  end

  def reservation_requests_on(date)
    reservations.where('tsrange("reservations"."start", "reservations"."end") <@ ' +
                    'tsrange(?, ?)', date.beginning_of_day, date.end_of_day)
  end

  def first_name
    #TODO: Replace this placeholder.
    email.split('@').first.split(/[._-]/).first
  end

  def last_name
    #TODO: Replace this placeholder.
    (email.split('@').first.split(/[._-]/) - [first_name]).last
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def status
    'active'
  end

  def self.strip_user_data(users)
    users = users.map do |user|
      [ user.id, user.full_name ].join(':')
    end
    users.join(',')
  end
end
