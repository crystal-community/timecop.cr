
#:nodoc:
struct Time
  @@mock : Bool = true

  def self.now_without_mock_time(location : Location = Location.local)
    @@mock = false
    result = now(location)
    @@mock = true
    result
  end

  def self.local(location : Location = Location.local) : Time
    return previous_def if !Timecop.frozen? || !@@mock
    Timecop.top_stack_item.time(location)
  end

  def self.utc : Time
    return previous_def if !Timecop.frozen? || !@@mock
    Timecop.top_stack_item.time(Location::UTC)
  end
end
