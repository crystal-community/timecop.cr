require "./spec_helper"

describe Timecop do
  
  it "freeze_changes_and_resets_time" do
    outer_freeze_time = Time.new(2001, 1, 1).to_local
    inner_freeze_block = Time.new(2002, 2, 2).to_local
    inner_freeze_one = Time.new(2003, 3, 3).to_local
    inner_freeze_two = Time.new(2004, 4, 4).to_local
    
    Timecop.freeze(outer_freeze_time) do
      true.should eq times_effectively_equal(outer_freeze_time, Time.now)
      Timecop.freeze(inner_freeze_block) do
        true.should eq times_effectively_equal(inner_freeze_block, Time.now)
        Timecop.freeze(inner_freeze_one)
        true.should eq times_effectively_equal(inner_freeze_one, Time.now)
        Timecop.freeze(inner_freeze_two)
        true.should eq times_effectively_equal(inner_freeze_two, Time.now)
      end
      true.should eq times_effectively_equal(outer_freeze_time, Time.now)
    end
  end
  
  it "freeze_yields_mocked_time" do
    date = Time.new(2008, 10, 10, 10, 10, 10)
    Timecop.freeze(date) do |frozen_time|
      true.should eq(frozen_time == Time.now)
    end
  end
end
