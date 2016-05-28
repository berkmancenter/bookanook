class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, omniauth_providers: [ :google_oauth2 ]

  STATUSES = [ :active, :banned ]

  has_many :reservations

  def admin?
    return has_role? :admin, :any
  end

  def superadmin?
    return has_role? :superadmin
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
