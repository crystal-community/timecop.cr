module Timecop
  class TimeStackItem

    getter mock_type : Symbol

    delegate :year, :month, :day, :hour, :minute, :second, to: :time

    def initialize(@mock_type, @time : Time = Time.now)
      if ![:freeze, :travel, :scale].includes?(mock_type)
        raise "Unknown mock_type #{mock_type}"
      end

      #@time_was = Time.now_without_mock_time
    end

    #:nodoc:
    def time
      @time
    end
  end
end
