require "administrate/fields/base"

class OpenAtField < Administrate::Field::Base

  def days
    data.spans
  end

  def to_s
    data
  end
end
