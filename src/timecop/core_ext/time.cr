
#:nodoc:
struct Time

  @@mock : Bool = true

  def self.now_without_mock_time
    @@mock = false
    result = now
    @@mock = true
    result
  end

  def self.now
    return previous_def if Timecop.stack.empty? || !@@mock
    Timecop.top_stack_item.time
  end

end
