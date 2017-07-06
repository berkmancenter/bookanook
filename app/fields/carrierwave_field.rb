require "administrate/field/base"

class CarrierwaveField < Administrate::Field::Base
  def urls
    data.map(&:url)
  end

  def thumbnails
    data.map{|d| d.thumb.url}
  end

  def to_s
    data
  end

  def self.permitted_attribute(attr)
    { "#{attr}".to_sym => [] }
  end
end
