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
    return Nook.none if has_default_params

    scope = Nook.where(bookable: true)

    scope = scope.merge(location_id: location_ids) unless location_ids.empty?

    scope = scope.
      and(nooks[:type].in(nook_types)) unless nook_types.empty?

    unless amenities.empty?
      amenities_sql = ActiveRecord::Base.send(
        :sanitize_sql_array, ['"nooks"."amenities"::text[] @> ARRAY[?]', amenities])
      filter = filter.and(Arel::Nodes::SqlLiteral.new(amenities_sql))
    end

    datetime_ranges.each do |range|
      "tsrange(start, end) @> && tsrange(:begin, :end)", begin: range.begin, end: range.end
      reservations = Reservation.arel_table
      filter = filter.and(reservations[:start].not_between(range)).
        and(reservations[:end].not_between(range))
    end

    all_results = Nook.joins('LEFT JOIN reservations ON ' +
                             'nooks.id = reservations.nook_id').where(filter)
    if nook.open_schedule
      return all_results.select do |nook|
        datetime_ranges.all?{ |range| nook.open_for_range? range }
      end
    end

    all_results
  end
end
