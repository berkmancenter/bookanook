class Reservation < ActiveRecord::Base
  belongs_to :nook
  belongs_to :requester, class_name: 'User', foreign_key: 'user_id'

  searchable do
    integer :nook_id
    string :status
    time :start
    time :end
  end
end
