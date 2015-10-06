class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  STATUSES = [ :active, :banned ]

  has_many :reservations

  def admin?
    #TODO: Replace this placeholder.
    true
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
end
