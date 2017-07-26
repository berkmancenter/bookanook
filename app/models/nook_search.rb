class NookSearch
  ATTRS = [:location_ids, :amenities, :nook_types, :nook_capacity, :time_range, :days]
  attr_reader *ATTRS + [:has_default_params]

  def initialize(params = {})
    Hash.transform_keys_to_symbols(params)
    @has_default_params = ((ATTRS - params.keys).sort == ATTRS.sort)
    @location_ids = params[:location_ids] || []
    @amenities = params[:amenities] || []
    @nook_types = params[:nook_types] || []
    @nook_capacity = params[:nook_capacity].to_i || 0
    # An array of Date objects
    @days = params[:days] || []

    # Everything should be done in local timezone
    # This should be seconds since midnight
    @time_range = params[:time_range] || { start: 0, end: 0 }
    @time_range[:start] = @time_range[:start].to_i
    @time_range[:end] = @time_range[:end].to_i
  end

  # Turns the days and time ranges into actual datetime ranges
  def datetime_ranges
    return [] if days.empty? || time_range[:start] == 0
    ranges = []
    days.each do |day|
      ranges << (day.to_time + time_range[:start]..
                 day.to_time + time_range[:end])
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
    if nook_capacity > 0
      scope = scope.where(
      "( min_capacity is null OR min_capacity <= :capacity ) AND
        ( :capacity <= max_capacity OR max_capacity is null)
      ", capacity: nook_capacity)
    end
    unless amenities.empty?
      scope = scope.tagged_with(amenities)
    end

    # Make sure each nook is available
    nooks = scope.select do |nook|
      if datetime_ranges.empty?
        nook.open_schedule.nil? || !nook.always_closed?
      else
        datetime_ranges.any?{ |range| nook.available_for? range }
      end
    end

    nooks
  end

  class Hash
    def self.transform_keys_to_symbols(value)
      return value if not value.is_a?(Hash)
      hash = value.inject({}){|memo,(k,v)| memo[k.to_sym] = Hash.transform_keys_to_symbols(v); memo}
      return hash
    end
  end
end
