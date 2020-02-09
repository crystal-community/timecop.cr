require "./spec_helper"

describe Timecop::TimeStackItem do
  it "properly delegates time-related methods" do
    time = Time.local(2012, 7, 28, 20, 0)

    Timecop::TimeStackItem.new(:freeze, time).tap do |stack_item|
      stack_item.year.should eq(time.year)
      stack_item.month.should eq(time.month)
      stack_item.day.should eq(time.day)
      stack_item.hour.should eq(time.hour)
      stack_item.minute.should eq(time.minute)
      stack_item.second.should eq(time.second)
    end
  end
end
