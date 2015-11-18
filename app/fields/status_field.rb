require "administrate/fields/base"

class StatusField < Administrate::Field::Base
  def statuses
    options.fetch(:statuses, [])
  end

  def to_s
    data
  end
end
