module Timecop
  enum MockType
    Freeze
    Travel
    Scale
  end

  class TimeStackItem
    getter mock_type : MockType

    delegate :year, :month, :day, :hour, :minute, :second,
      to: @time

    @prev_time : Time
    @monotonic : Time::Span
    @instant : Time::Instant

    def initialize(@mock_type : MockType, @time : Time, @scaling_factor : Float64 = 1.0)
      @prev_time = Time.local_without_mock_time
      @monotonic = Time.monotonic_without_mock_time
      @instant = Time.instant_without_mock_time
    end

    def initialize(@mock_type : MockType, @scaling_factor : Float64 = 1.0)
      initialize(@mock_type, Time.local, @scaling_factor)
    end

    # :nodoc:
    def time(location : Time::Location = Time::Location.local) : Time
      case @mock_type
      when .freeze?
        @time.in(location)
      when .travel?
        offset = @time - @prev_time
        Time.local_without_mock_time(location) + offset
      when .scale?
        diff = Time.local_without_mock_time(location) - @prev_time
        @time + (diff * @scaling_factor)
      else
        raise "Unknown mock_type #{@mock_type}"
      end
    end

    # :nodoc:
    def monotonic : Time::Span
      case @mock_type
      when .freeze?
        @monotonic + (@time - @prev_time)
      when .travel?
        offset = @time - @prev_time
        Time.monotonic_without_mock_time + offset
      when .scale?
        diff = Time.monotonic_without_mock_time - @monotonic
        @monotonic + (diff * @scaling_factor)
      else
        raise "Unknown mock_type #{@mock_type}"
      end
    end

    # :nodoc:
    def instant : Time::Instant
      case @mock_type
      when .freeze?
        @instant + (@time - @prev_time)
      when .travel?
        offset = @time - @prev_time
        Time.instant_without_mock_time + offset
      when .scale?
        diff = Time.instant_without_mock_time - @instant
        @instant + (diff * @scaling_factor)
      else
        raise "Unknown mock_type #{@mock_type}"
      end
    end
  end
end
