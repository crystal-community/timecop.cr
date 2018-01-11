require "spec"
require "../src/timecop"

def times_effectively_equal(time1, time2, seconds_interval = 1)
  (time1 - time2).abs.to_i <= seconds_interval
end
