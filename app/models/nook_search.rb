class NookSearch
  ATTRS = [:location_ids, :amenities, :nook_types, :time_range, :days]
  attr_reader *ATTRS + [:has_default_params]

  def initialize(params = {})
    @has_default_params = ((ATTRS - params.keys).sort == ATTRS.sort)
    @location_ids = params[:location_ids] || []
    @amenities = params[:amenities] || []
    @nook_types = params[:nook_types] || []

    # An array of Date objects
    @days = params[:days] || []

    # Everything should be done in local timezone
    # This should be seconds since midnight
    @time_range = params[:time_range] || { start: 0, end: 0 }
  end

  # Turns the days and time ranges into actual datetime ranges
  def datetime_ranges
    return [] if days.empty? || time_range[:start] == 0
    ranges = []
    days.each do |day|
      ranges << (day.to_time + time_range[:start].seconds..
                 day.to_time + time_range[:end].seconds)
    end
    ranges
  end

  # I tried to use Sunspot here, but it's any_of..without..between chain is
  # really buggy.
  def results
    # maybe it should show all the nooks when no filters?
    # return Nook.none if has_default_params

    scope = Nook.where(bookable: true)
    scope = scope.where(location_id: location_ids) unless location_ids.empty?
    scope = scope.where(type: nook_types) unless nook_types.empty?

    unless amenities.empty?
      scope = scope.where('"nooks"."amenities"::text[] @> ARRAY[?]', amenities)
    end

    unless datetime_ranges.empty?
      return scope.select do |nook|
        puts nook.id
        puts nook.open_schedule.inspect
        datetime_ranges.any?{ |range| nook.available_for? range; puts nook.available_for?(range) }
      end
    end

    scope
  end
end
