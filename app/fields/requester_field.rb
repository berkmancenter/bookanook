require "administrate/fields/belongs_to"

class RequesterField < Administrate::Field::BelongsTo

  def self.permitted_attribute(attr)
    :user_id
  end

  def to_s
  	return '' if data.nil?
    data.full_name
  end
end
