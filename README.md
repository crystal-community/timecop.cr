# timecop.cr

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

Run a time-sensitive test

```crystal
date = Time.new(2008, 10, 10, 10, 10, 10)
Timecop.freeze(date) do |frozen_time|
  puts "#{frozen_time == Time.now}" # => true
end
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
