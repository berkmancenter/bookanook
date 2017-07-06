require "administrate/field/base"

class SelectizeField < Administrate::Field::Base
  def to_s
    data.pluck(:name).join(',')
  end
end
