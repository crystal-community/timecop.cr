require "./timecop/*"
require "./timecop/core_ext/*"

module Timecop
  extend self

  @@stack = [] of TimeStackItem
  @@safe_mode = false

  # Returns whether or not Timecop is currently frozen/travelled/scaled
  def frozen?
    !@@stack.empty?
  end

  # Allows you to run a block of code and "fake" a time throughout the execution of that block.
  def freeze(time : Time)
    send_travel(:freeze, time)
  end

  # Allows you to run a block of code and "fake" a time throughout the execution of that block.
  def freeze(time : Time, &block : Time -> )
    send_travel(:freeze, time, &block)
  end

  # Allows you to run a block of code and "fake" a time throughout the execution of that block.
  def travel(time : Time)
    send_travel(:travel, time)
  end

  def travel(time : Time, &block : Time -> )
    send_travel(:travel, time, &block)
  end

  # Allows you to run a block of code and "scale" a time throughout the execution of that block.
  # The first argument is a scaling factor, for example:
  #   Timecop.scale(2) do
  #     ... time will 'go' twice as fast here
  #   end
  # Returns the value of the block if one is given, or the mocked time.
  def scale(time : Time, factor : Float64)
    send_travel(:scale, time, factor)
  end
  
  def scale(time : Time, factor : Float64, &block : Time -> )
    send_travel(:scale, time, factor, &block)
  end

  # Reverts back to system's Time.now
  def return
    unmock!
  end

  # Reverts back to system's Time.now
  def return(&block)
    stack_backup = @@stack.dup
    unmock!
    yield
  ensure
    @@stack = stack_backup.as(Array(Timecop::TimeStackItem))
  end
  
  def safe_mode=(safe)
    @@safe_mode = safe
  end

  def safe_mode?
    @@safe_mode
  end

  # :nodoc:
  private def unmock!
    @@stack.clear
  end

  # :nodoc:
  private def send_travel(mock_type, *args)
    raise SafeModeException.new if @@safe_mode
    @@stack << TimeStackItem.new(mock_type, *args)
    Time.now
  end

  # :nodoc:
  private def send_travel(mock_type, *args, &block : Time -> )
    stack_item = TimeStackItem.new(mock_type, *args)
    stack_backup = @@stack.dup
    @@stack << stack_item
    begin
      result = block.call stack_item.time
      @@stack.pop
      result
    ensure
      @@stack.replace stack_backup
    end
  end

  #:nodoc:
  def top_stack_item
    @@stack.last
  end
end
