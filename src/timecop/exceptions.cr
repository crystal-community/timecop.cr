module Timecop
  class SafeModeException < Exception
    def initialize
      super("Safe mode is enabled, only calls passing a block are allowed")
    end
  end
end
