# timecop.cr
[![Build Status](https://travis-ci.org/TobiasGSmollett/timecop.cr.svg?branch=master)](https://travis-ci.org/TobiasGSmollett/timecop.cr)

A [timecop](https://github.com/travisjeffery/timecop) inspire library allow "time travel", "freezing time" and "time acceleration" capabilities, making it simple to test time-dependent code.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  timecop:
    github: TobiasGSmollett/timecop.cr
```

## Usage

```crystal
require "timecop"
```

### Timecop.freeze
```crystal
date = Time.new(2008, 10, 10, 10, 10, 10)
Timecop.freeze(date) do |frozen_time|
  puts "#{frozen_time == Time.now}" # => true
end
```

### Timecop.travel
```crystal
Timecop.travel(Time.new(2014, 1, 1, 0, 0, 0)) do
  puts Time.now # => 2014-01-01 00:00:00 +0900
  sleep(5)
  puts Time.now # => 2014-01-01 00:00:05 +0900
end
```

### Timecop.scale
```crystal
# seconds will now seem like hours
Timecop.scale(Time.now, 3600)
puts Time.now # => 2017-08-28 23:50:06 +0900
sleep(2.0)
# seconds later, hours have passed and it's gone from 23pm at night to 1am in the morning
puts Time.now # => 2017-08-29 01:50:21 +0900
```

### Timecop.safe_mode
```crystal
# turn on safe mode
Timecop.safe_mode = true

Timecop.safe_mode? # => true

# using method without block
Timecop.freeze Time.new(2008, 10, 10, 10, 10, 10)
# => Timecop::SafeModeException: Safe mode is enabled, only calls passing a block are allowed.
```

## Development

Pull Request Welcome

## Contributing

1. Fork it ( https://github.com/TobiasGSmollett/timecop.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [TobiasGSmollett](https://github.com/TobiasGSmollett) TobiasGSmollett - creator, maintainer

## Thanks
Thanks to Travis Jeffery for his awesome work on [timecop](https://github.com/travisjeffery/timecop).
