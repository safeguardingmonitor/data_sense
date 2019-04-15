# DataSense

This gem provides a wrapper around the [BrightBytes DataSense](https://www.brightbytes.net/datasense-edtech) OneRoster v1.1 API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'data_sense'
```

And then execute:

```ruby
$ bundle
```

Or install it yourself as:

```ruby
$ gem install data_sense
```

## Usage

```ruby
require "data_sense"
api = DataSense::Api.new(subscription_key: "YOUR_SUBSCRIPTION_KEY_HERE")
```

To retrieve all items in a collection:

```ruby
api.demographics.all
```

To retrieve a single item in a collection by UUID:

```ruby
api.schools.get(uuid: "431a001d-4625-4601-9415-28ecb67fd999")
```

To pass query parameters to a collection:

```ruby
api.orgs.where(fields: ["name", "type"], filter: { type: "district" })
api.orgs.where(limit: 5, sort: "name ASC")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/safeguardingmonitor/data_sense. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0).

## Code of Conduct

Everyone interacting in the DataSense project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/safeguardingmonitor/data_sense/blob/master/CODE_OF_CONDUCT.md).
