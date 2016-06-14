require "administrate/fields/belongs_to"

class NookField < Administrate::Field::BelongsTo
  def to_s
  	return '' if data.nil?
    data.name
  end
end
