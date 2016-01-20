require "administrate/fields/base"

class OpenAtField < Administrate::Field::Base

  def days
    data.spans
  end

  def days_text
    return [] if data.nil?
    data.open_ranges.reject(&:empty?).map do |spans|
      in_day_spans = spans.map do |range|
        range.begin.strftime('%l:%M %P - ') + range.end.strftime('%l:%M %P')
      end
      spans.first.begin.strftime('%a: ') + in_day_spans.join(', ')
    end
  end

  def to_s
    data
  end
end
