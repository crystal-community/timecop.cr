require "./spec_helper"

describe Timecop do
  it "doesn't break when `Time.utc/local` is used" do
    typeof(Time.utc)
    typeof(Time.local)
  end

  context ".freeze" do
    it "changes and resets time" do
      outer_freeze_time = Time.local(2001, 1, 1)
      inner_freeze_block = Time.local(2002, 2, 2)
      inner_freeze_one = Time.local(2003, 3, 3)
      inner_freeze_two = Time.local(2004, 4, 4)

      Timecop.freeze(outer_freeze_time) do
        outer_freeze_time.should be_close(Time.local, 1.second)

        Timecop.freeze(inner_freeze_block) do
          inner_freeze_block.should be_close(Time.local, 1.second)

          Timecop.freeze(inner_freeze_one)
          inner_freeze_one.should be_close(Time.local, 1.second)

          Timecop.freeze(inner_freeze_two)
          inner_freeze_two.should be_close(Time.local, 1.second)
        end
        outer_freeze_time.should be_close(Time.local, 1.second)
      end
    end

    it "yields mocked time" do
      time = Time.local(2008, 10, 10, 10, 10, 10)
      Timecop.freeze(time) do |frozen_time|
        frozen_time.should eq(Time.local)
      end
    end

    it "with return unsets mock time" do
      Timecop.freeze(Time.local)
      Timecop.return
      Timecop.frozen?.should be_false
    end

    it "with block unsets mock time" do
      Timecop.frozen?.should be_false
      Timecop.freeze(Time.local) { }
      Timecop.frozen?.should be_false
    end

    it "restores previous time on raised exception within block" do
      time = Time.local(2008, 10, 10, 10, 10, 10)
      Timecop.freeze(time) do
        Timecop.return { raise "foobar" } rescue nil
        time.should eq(Time.local)
      end
    end

    it "allows asking for the time with .local" do
      time = Time.local
      Timecop.freeze(time) do |t|
        sleep(250.milliseconds)
        Time.local.should eq(t)
      end
    end

    it "allows asking for the time with .utc" do
      time = Time.utc
      Timecop.freeze(time) do |t|
        sleep(250.milliseconds)
        Time.utc.should eq(t)
      end
    end

    context "monotonic" do
      it "prevents moving time elapsed" do
        time = Time.local(2008, 10, 10, 10, 10, 10)

        Timecop.freeze(time) do
          start = Time.monotonic
          sleep(250.milliseconds)
          Time.monotonic.should eq(start)
        end
      end

      it "changes the time elapsed" do
        time = Time.local(2008, 10, 10, 10, 10, 10)
        elapsed = 5.minutes

        Timecop.freeze(time) do
          start = Time.monotonic
          Timecop.freeze(time + elapsed)
          Time.monotonic.should be_close(start + elapsed, 1.milliseconds)
        end
      end
    end
  end

  context ".scale" do
    it "keeps time moving at an accelerated rate" do
      time = Time.local(2008, 10, 10, 10, 10, 10)
      Timecop.scale(time, 4) do
        start = Time.local
        start.should be_close(time, 1.second)
        sleep(250.milliseconds)
        (start + 1.second).should be_close(Time.local, 250.milliseconds)
      end
    end

    it "returns `now` if no block given" do
      time = Time.local(2008, 10, 10, 10, 10, 10)
      time.should be_close(Timecop.scale(time, 4), 1.second)
    end

    context "monotonic" do
      it "keeps time moving at an accelerated rate" do
        time = Time.local(2008, 10, 10, 10, 10, 10)
        Timecop.scale(time, 4) do
          start = Time.monotonic
          sleep(250.milliseconds)
          (start + 1.second).should be_close(Time.monotonic, 250.milliseconds)
        end
      end
    end
  end

  context ".travel" do
    it "keeps time moving" do
      time = Time.local(2008, 10, 10, 10, 10, 10)
      Timecop.travel(time) do
        start = Time.local
        start.should be_close(time, 1.second)
        sleep(250.milliseconds)
        start.should_not be_close(Time.local, 240.milliseconds)
      end
    end

    pending "does not reduce precision" do
      Timecop.travel(Time.local(2014, 1, 1, 0, 0, 0))
      Time.local.should_not eq(Time.local)

      Timecop.travel(Time.local(2014, 1, 1, 0, 0, 59))
      Time.local.should_not eq(Time.local)
    end

    context "monotonic" do
      it "keeps time moving" do
        time = Time.local(2008, 10, 10, 10, 10, 10)
        Timecop.travel(time) do
          start = Time.monotonic
          sleep(250.milliseconds)
          finish = Time.monotonic
          elapsed = finish - start
          elapsed.should_not be_close(finish, 240.milliseconds)
        end
      end
    end
  end
end
