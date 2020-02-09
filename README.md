# timecop.cr

[![Build Status](https://travis-ci.com/crystal-community/timecop.cr.svg?branch=master)](https://travis-ci.com/crystal-community/timecop.cr) [![Releases](https://img.shields.io/github/release/crystal-community/timecop.cr.svg)](https://github.com/crystal-community/timecop.cr/releases) [![License](https://img.shields.io/github/license/crystal-community/timecop.cr.svg)](https://github.com/crystal-community/timecop.cr/blob/master/LICENSE)

A [timecop](https://github.com/travisjeffery/timecop) inspired library to allow easy manipulation of time in tests. Originally authored by [TobiasGSmollett](https://github.com/TobiasGSmollett).

## Installation

Add this to your application's `shard.yml`:

```diff
dependencies:
+  timecop:
+    github: crystal-community/timecop.cr
```

## Usage

```crystal
require "timecop"
```

### `Timecop.freeze`

```crystal
time = Time.local(2008, 10, 10, 10, 10, 10)
Timecop.freeze(time) do |frozen_time|
  frozen_time == Time.local # => true
end
```

### `Timecop.travel`

```crystal
Timecop.travel(Time.local(2014, 1, 1, 0, 0, 0)) do
  Time.local # => "2014-01-01 00:00:00 +0900"
  sleep(5.seconds)
  Time.local # => "2014-01-01 00:00:05 +0900"
end
```

### `Timecop.scale`

```crystal
# seconds will now seem like hours
Timecop.scale(3600)

Time.local # => "2017-08-28 23:50:06 +0900"

sleep(2.seconds)
# 2 seconds later, hours have passed and it's gone from
# 23pm at night to 1am in the morning

Time.local # => "2017-08-29 01:50:21 +0900"
```

### `Timecop.safe_mode`

```crystal
Timecop.safe_mode? # => false
Timecop.safe_mode = true

# using method without block
Timecop.freeze Time.local(2008, 10, 10, 10, 10, 10)
# => raises Timecop::SafeModeException
```

## Development

Pull Requests Welcome!

## Contributing

1. Fork it (<https://github.com/TobiasGSmollett/timecop.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [TobiasGSmollett](https://github.com/TobiasGSmollett) - creator
- [Robacarp](https://github.com/robacarp) - maintainer
- [Sija](https://github.com/Sija) - maintainer

## Thanks
Thanks to Travis Jeffery for his awesome work on [timecop](https://github.com/travisjeffery/timecop).
