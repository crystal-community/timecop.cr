module Timecop
  class SafeModeException < Exception
    @message = "Safe mode is enabled, only calls passing a block are allowed."
  end
end