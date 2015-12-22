require "administrate/fields/base"

class SelectizeField < Administrate::Field::Base
  def to_s
    data.pluck(:name).join(',')
  end
end
