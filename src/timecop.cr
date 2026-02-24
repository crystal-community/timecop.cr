require "./timecop/*"
require "./timecop/core_ext/*"

module Timecop
  extend self

  class_property? safe_mode = false

  @@stack = [] of TimeStackItem

  # Returns whether or not `Timecop` is currently frozen/travelled/scaled
  def frozen? : Bool
    !@@stack.empty?
  end

  # Allows you to run a block of code and "fake" a time throughout
  # the execution of that block.
  def freeze(time : Time) : Time
    send_travel(:freeze, time)
  end

  # :ditto:
  def freeze(time : Time, & : Time -> V) : V forall V
    send_travel(:freeze, time) { |frozen_time| yield frozen_time }
  end

  # :ditto:
  def travel(time : Time) : Time
    send_travel(:travel, time)
  end

  # :ditto:
  def travel(time : Time, & : Time -> V) : V forall V
    send_travel(:travel, time) { |frozen_time| yield frozen_time }
  end

  # Allows you to run a block of code and "scale" a time throughout
  # the execution of that block.
  #
  # ```
  # Timecop.scale(2) do
  #   # ... time will 'go' twice as fast here
  # end
  # ```
  #
  # Returns the value of the block if one is given, or the mocked time.
  def scale(factor : Float64) : Time
    send_travel(:scale, factor)
  end

  # :ditto:
  def scale(time : Time, factor : Float64) : Time
    send_travel(:scale, time, factor)
  end

  # :ditto:
  def scale(factor : Float64, & : Time -> V) : V forall V
    send_travel(:scale, factor) { |scaled_time| yield scaled_time }
  end

  # :ditto:
  def scale(time : Time, factor : Float64, & : Time -> V) forall V
    send_travel(:scale, time, factor) { |scaled_time| yield scaled_time }
  end

  # Reverts back to system's `Time.local`
  def return : Nil
    unmock!
  end

  # :ditto:
  def return(& : -> V) : V forall V
    prev_stack = @@stack.dup
    begin
      unmock!
      yield
    ensure
      @@stack = prev_stack
    end
  end

  private def unmock! : Nil
    @@stack.clear
  end

  private def send_travel(mock_type : MockType, *args) : Time
    if safe_mode?
      raise SafeModeException.new
    end
    @@stack << TimeStackItem.new(mock_type, *args)
    Time.local
  end

  private def send_travel(mock_type : MockType, *args, & : Time -> V) : V forall V
    prev_stack = @@stack.dup
    stack_item = TimeStackItem.new(mock_type, *args)
    begin
      @@stack << stack_item
      yield(stack_item.time).tap do
        @@stack.pop
      end
    ensure
      @@stack = prev_stack
    end
  end

  # :nodoc:
  def top_stack_item
    @@stack.last
  end
end
