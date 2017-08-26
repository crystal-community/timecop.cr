module Timecop
  class TimeStackItem
    
    getter mock_type : Symbol
    
    def initialize(@mock_type, @time : Time = Time.now)
      if ![:freeze, :travel, :scale].includes?(mock_type)
        raise "Unknown mock_type #{mock_type}"
      end

      #@time_was = Time.now_without_mock_time
    end
    
    def year
      @time.year
    end
    
    def month
      @time.month
    end
    
    def day
      @time.day
    end
    
    def hour
      @time.hour
    end
    
    def min
      @time.minute
    end
    
    def sec
      @time.second
    end

    #:nodoc:
    def time
      @time
    end
  end
end
