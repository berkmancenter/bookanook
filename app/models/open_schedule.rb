# Open schedules is just a long boolean mask. Each boolean value is a "block"
# because it can represent something like 15 minutes. The mask is broken into
# "spans", where each span is something like a "day". This is just for
# convenience of the caller. The full mask can represent something like
# a "week". It starts on a date and repeats if it runs off the end of the mask.

class OpenSchedule < ActiveRecord::Base
  after_initialize :set_defaults
  after_initialize :init_spans

  validate :num_spans_divides_num_blocks_evenly
  validates_numericality_of :duration, greater_than: 0

  attr_accessor :spans

  A_SUNDAY_AT_LOCAL_MIDNIGHT = Time.new(2015, 6, 7)

  def add_open_range(range)
    add_range(range, true)
  end

  def add_closed_range(range)
    add_range(range, false)
  end

  def open_at?(time)
    blocks[block_index_from_time(time)]
  end

  def closed_at?(time)
    !open_at?(time)
  end

  def open_now?
    open_at?(Time.now)
  end

  def closed_now?
    !open_now?
  end

  def open_for_range?(range)
    blocks.values_at(*indices_for_range(range)).all?
  end

  def closed_for_range?(range)
    !open_for_range?(range)
  end

  def open_ranges_containing(time)
    time_shift = ((time - start) / duration).floor * duration
    # Walk through each span
    spans.map.with_index do |span, span_i|
      # RLE it, throw out the closed, and only care about the indices
      open_indices = span.each_index.chunk{ |i| span[i] }.select{ |open, _| open }

      # For each group of indices, return a time range
      shift = span_i * blocks_per_span
      open_indices.map do |open, indices|
        (time_from_block_index(indices.first + shift) + time_shift)..
          (time_from_block_index(indices.last + shift) + time_shift)
      end
    end
  end

  def open_ranges
    open_ranges_containing(Time.now)
  end

  def span_duration
    schedule_duration / num_spans
  end

  def respond_to?(method, include_private = false)
    return true if method == span_name.pluralize.to_sym
    super
  end

  def method_missing(method, *args, &block)
    return spans if method == span_name.pluralize.to_sym
    super
  end

  def add_9_to_5
    (duration / 1.day).times do |i|
      date = (start + i.days).to_time
      next if date.saturday? || date.sunday?
      add_open_range(date.change(hour: 9)..date.change(hour: 17))
    end
    self
  end

  private

  def block_index_from_time(time, rounding: :floor)
    seconds_since_start = (time - start) % duration
    (seconds_since_start / seconds_per_block).send(rounding)
  end

  def time_from_block_index(index)
    (start + (index * seconds_per_block).seconds).to_time
  end

  def indices_for_range(range)
    # Return everything if our range is too big
    range_duration = (range.end - range.begin).seconds
    return (0...blocks.count).to_a if range_duration >= duration

    start_i = block_index_from_time(range.begin)
    end_i = block_index_from_time(range.end)

    # Return the simple case where the range doesn't fall on a boundary
    return (start_i..end_i).to_a if start_i < end_i

    # If the range falls on a boundary, wrap around
    (0..end_i).to_a + (start_i...blocks.count).to_a
  end

  def add_range(range, value)
    indices_for_range(range).each{ |i| self.blocks[i] = value }
  end

  def num_spans
    blocks.count / blocks_per_span
  end

  def set_defaults
    self.duration ||= 1.week
    self.seconds_per_block ||= 15.minutes.value
    self.blocks_per_span ||= 24.hours.value / self.seconds_per_block
    self.span_name ||= 'day'
    self.name ||= 'Weekly Hours'
    self.blocks = [false] * (duration / seconds_per_block) if blocks.empty?

    # The week starts on Sunday at midnight. Open 9 to 5.
    self.start ||= A_SUNDAY_AT_LOCAL_MIDNIGHT
  end

  def init_spans
    self.spans = blocks.each_slice(blocks_per_span)
  end

  def blocks_divide_duration_evenly
    if duration % seconds_per_block != 0
      errors.add(:seconds_per_block, "must divide evenly into the duration")
    end
  end

  def num_spans_divides_num_blocks_evenly
    if blocks.count % blocks_per_span != 0
      errors.add(:blocks_per_span, "must divide evenly the number of blocks evenly")
    end
  end
end
