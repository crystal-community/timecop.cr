# :nodoc:
struct Time
  @@mock : Bool = true

  def self.local_without_mock_time(location : Location = Location.local)
    @@mock = false
    local(location)
  ensure
    @@mock = true
  end

  def self.monotonic_without_mock_time
    @@mock = false
    monotonic
  ensure
    @@mock = true
  end

  def self.instant_without_mock_time : Time::Instant
    @@mock = false
    instant
  ensure
    @@mock = true
  end

  def self.local(location : Location = Location.local) : Time
    return previous_def if !Timecop.frozen? || !@@mock
    Timecop.top_stack_item.time(location)
  end

  def self.utc : Time
    return previous_def if !Timecop.frozen? || !@@mock
    Timecop.top_stack_item.time(Location::UTC)
  end

  def self.monotonic : Time::Span
    return previous_def if !Timecop.frozen? || !@@mock
    Timecop.top_stack_item.monotonic
  end

  def self.instant : Time::Instant
    return previous_def if !Timecop.frozen? || !@@mock
    Timecop.top_stack_item.instant
  end
end
