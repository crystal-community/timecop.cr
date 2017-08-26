
#:nodoc:
struct Time
  
  def self.without_mock_now
    Time.new Time.local_ticks, kind: Kind::Local
  end
  
  def self.now
    return without_mock_now if Timecop.stack.empty?
    Timecop.top_stack_item.time
  end
  
end

