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

    nooks = Nook.arel_table
    filter = nooks[:bookable].eq(true)

    filter = filter.
      and(nooks[:location_id].in(location_ids)) unless location_ids.empty?

    filter = filter.
      and(nooks[:type].in(nook_types)) unless nook_types.empty?

    unless amenities.empty?
      amenities_sql = ActiveRecord::Base.send(
        :sanitize_sql_array, ['"nooks"."amenities"::text[] @> ARRAY[?]', amenities])
      filter = filter.and(Arel::Nodes::SqlLiteral.new(amenities_sql))
    end

    datetime_ranges.each do |range|
      reservations = Reservation.arel_table
      filter = filter.and(reservations[:start].not_between(range)).
        and(reservations[:end].not_between(range))
    end

    Nook.joins('LEFT JOIN reservations ON nooks.id = reservations.nook_id').
      where(filter)
  end
end
