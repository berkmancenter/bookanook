class NookSearch
  ATTRS = [:location_ids, :amenities, :nook_types, :time_range, :days]
  attr_reader *ATTRS + [:has_default_params]

  def initialize(params = {})
    @has_default_params = ((ATTRS - params.keys).sort == ATTRS.sort)
    @location_ids = params[:location_ids] || []
    @amenities = params[:amenities] || []
    @nook_types = params[:nook_types] || []

    # An array of Time objects at midnight
    @days = params[:days] || []

    # This should be seconds since midnight
    @time_range = { start: 0, end: 0 } || params[:time_range]
  end

  def datetime_ranges
    return [] if days.empty? || time_range[:start] == 0
    ranges = []
    days.each do |day|
      ranges << [day + time_range[:start], day + time_range[:end]]
    end
  end

  def results
    return Nook.none if has_default_params

    search = Nook.search do
      with :location_id, location_ids unless location_ids.empty?
      with :amenities, amenities unless amenities.empty?
      with :type, nook_types unless nook_types.empty?
      with :bookable, true

      unless datetime_ranges.empty?
        any_of do
          datetime_ranges.each do |range|
            without(:reservations_starting).between(range.first, range.last)
          end
        end
      end
    end

    search.results
  end
end
