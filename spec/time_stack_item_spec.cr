require "./spec_helper"

describe Timecop do

  it "new_with_time" do
    t = Time.now
    y, m, d, h, min, s = t.year, t.month, t.day, t.hour, t.minute, t.second
    stack_item = Timecop::TimeStackItem.new(:freeze, t)

    true.should eq(y == stack_item.year)
    true.should eq(m == stack_item.month)
    true.should eq(d == stack_item.day)
    true.should eq(h == stack_item.hour)
    true.should eq(min == stack_item.minute)
    true.should eq(s == stack_item.second)
  end

  it "new_with_time_and_arguments" do
    t = Time.new(2012, 7, 28, 20, 0)
    y, m, d, h, min, s = t.year, t.month, t.day, t.hour, t.minute, t.second
    stack_item = Timecop::TimeStackItem.new(:freeze, t)

    true.should eq(y == stack_item.year)
    true.should eq(m == stack_item.month)
    true.should eq(d == stack_item.day)
    true.should eq(h == stack_item.hour)
    true.should eq(min == stack_item.minute)
    true.should eq(s == stack_item.second)
  end
end
