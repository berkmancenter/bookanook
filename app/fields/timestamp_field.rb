require "administrate/field/base"

class TimestampField < Administrate::Field::Base
  def to_s
    data
  end

  def humanize
    data.strftime('%b %d %Y, %a, %I:%M %P')
  end
end
