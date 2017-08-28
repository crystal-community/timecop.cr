require "./timecop/*"
require "./timecop/core_ext/*"

module Timecop
  extend self

  @@stack = [] of TimeStackItem

  def stack
    @@stack
  end

  def freeze(*args)
    send_travel(:freeze, *args)
  end

  def freeze(*args, &block : Time ->)
    send_travel(:freeze, *args, &block)
  end

  def travel(*args)
    send_travel(:travel, *args)
  end

  def travel(*args, &block : Time ->)
    send_travel(:travel, *args, &block)
  end

  def return
    unmock!
  end

  def return(&block)
    stack_backup = @@stack.dup
    unmock!
    yield
  ensure
    @@stack = stack_backup.as(Array(Timecop::TimeStackItem))
  end

  private def unmock!
    @@stack.clear
  end

  private def send_travel(mock_type, *args)
    #raise SafeModeException if Timecop.safe_mode? && !@safe
    @@stack << TimeStackItem.new(mock_type, *args)
    Time.now
  end

  private def send_travel(mock_type, *args, &block : Time -> )
    stack_item = TimeStackItem.new(mock_type, *args)
    stack_backup = @@stack.dup
    @@stack << stack_item
    begin
      block.call stack_item.time
    ensure
      @@stack.replace stack_backup
    end
  end

  #:nodoc:
  def top_stack_item
    @@stack.last
  end
end
