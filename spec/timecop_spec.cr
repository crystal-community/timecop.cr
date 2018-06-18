require "./spec_helper"

Spec.before_each { Timecop.return }
Spec.after_each { Timecop.return }

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

  it "freeze_then_return_unsets_mock_time" do
    Timecop.freeze(Time.new)
    Timecop.return
    true.should eq !Timecop.frozen?
  end

  it "freeze_with_block_unsets_mock_time" do
    true.should eq !Timecop.frozen?
    Timecop.freeze(Time.new) do; end
    true.should eq !Timecop.frozen?
  end

  it "travel_with_block_unsets_mock_time" do
    true.should eq !Timecop.frozen?
    Timecop.travel(Time.new) do; end
    true.should eq !Timecop.frozen?
  end

  it "scaling_keeps_time_moving_at_an_accelerated_rate" do
    t = Time.new(2008, 10, 10, 10, 10, 10).to_local
    Timecop.scale(t, 4) do
      start = Time.now
      true.should eq times_effectively_equal start, t
      sleep(0.25)
      true.should eq times_effectively_equal (start + Time::Span.new(0, 0, 0, 1)), Time.now, 0.25
    end
  end
  
  it "scaling_returns_now_if_no_block_given" do
    t = Time.new(2008, 10, 10, 10, 10, 10).to_local
    true.should eq times_effectively_equal t, Timecop.scale(t, 4)
  end

  it "exception_thrown_in_return_block_restores_previous_time" do
    t = Time.new(2008, 10, 10, 10, 10, 10).to_local
    Timecop.freeze(t) do
      Timecop.return { raise "foobar" } rescue nil
      true.should eq(t == Time.now)
    end
  end

  it "travel_keeps_time_moving" do
    t = Time.new(2008, 10, 10, 10, 10, 10).to_local
    now = Time.now
    Timecop.travel(t) do
      new_now = Time.now
      true.should eq times_effectively_equal(new_now, t)
      sleep(0.25)
      false.should eq times_effectively_equal new_now, Time.now, 0.24
    end
  end

  pending "travel_does_not_reduce_precision_of_datetime" do
    Timecop.travel(Time.new(2014, 1, 1, 0, 0, 0))
    true.should eq (Time.now != Time.now)

    Timecop.travel(Time.new(2014, 1, 1, 0, 0, 59))
    true.should eq (Time.now != Time.now)
  end
end
