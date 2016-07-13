class Notification < ActiveRecord::Base
  belongs_to :actor, class_name: 'User', foreign_key: 'actor_id'
  belongs_to :user
  belongs_to :reservation # not necessary

  scope :unseen, -> { where(seen: false) }
  scope :seen, -> { where(seen: true) }

  def message
    return I18n.t("messages.#{message_id}") if reservation.nil?
    I18n.t(
      "messages.#{message_id}",
      reservation_name: reservation.name,
      nook_name: reservation.nook.name,
      actor_name: actor.full_name
    )
  end

  def self.get_message_id(status)
    case status
    when Reservation::Status::CONFIRMED
      return 1
    when Reservation::Status::REJECTED
      return 2
    when Reservation::Status::CANCELED
      return 3
    when Reservation::Status::PENDING
      return 5
    end
  end
end
