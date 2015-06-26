module OpenAtHours
  extend ActiveSupport::Concern

  included do
    belongs_to :open_schedule
    delegate :add_open_range, :add_closed_range, :open_at?, :closed_at?,
      :open_now?, :closed_now?, :open_for_range?, :closed_for_range?,
      :schedule_duration, :span_duration, to: :open_schedule
  end
end
