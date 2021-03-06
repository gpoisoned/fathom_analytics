![CI Specs](https://github.com/gpoisoned/fathom_analytics/workflows/CI%20Specs/badge.svg?branch=master) [![Gem Version](https://badge.fury.io/rb/fathom_analytics.svg)](https://badge.fury.io/rb/fathom_analytics)
# Fathom Analytics Ruby Client

A Ruby interface to [Fathom Analytics server](https://github.com/usefathom/fathom).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fathom_analytics'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install fathom_analytics

## Usage

#### Creating an instance of the API client:

``` ruby
api = FathomAnalytics::Api.new(url: 'https://example.com', email: '', password: '')
```

#### Authentication:
``` ruby
api.authenticate
```
Note: Any other api call without prior authentication will implicitly call `authenticate`.

#### Get all sites:
``` ruby
api.sites
```

#### Add a new site:
``` ruby
api.add_site(name: 'demo')
```

#### Remove a site:
``` ruby
api.remove_site(id: 1)
```

#### Get realtime site stats:
``` ruby
api.site_realtime_stats(id: 1)
```

#### Get site stats:
``` ruby
api.site_stats(id: 1, from: 1577862000, to: 1609484399)
```

#### Get aggregated site stats:
``` ruby
api.site_agg_stats(id: 1, from: 1577862000, to: 1609484399)
```

#### Get aggregated page stats:
``` ruby
api.page_agg_stats(id: 1, from: 1577862000, to: 1609484399)
```

#### Get aggregated page views:
``` ruby
api.page_agg_page_views_stats(id: 1, from: 1577862000, to: 1609484399)
```

#### Get aggregated referrer stats:
``` ruby
api.referrer_agg_stats(id: 1, from: 1577862000, to: 1609484399)
```

#### Get aggregated referrer page views:
``` ruby
api.referrer_agg_page_views_stats(id: 1, from: 1577862000, to: 1609484399)
```

#### Pagination

Pagination is supported through `offset` and `limit` params.
``` ruby
api.page_agg_page_views_stats(id: 1, from: 1577862000, to: 1609484399, offset: 10, limit: 10) # Second page
```
The default values for paginations params are as follows:
1. `limit`  = 50
2. `offset` = 0

#### Handling API Errors

The api call will raise an error `FathomAnalytics::Error` when it fails.
``` ruby
begin
  api.authenticate
rescue FathomAnalytics::Error => e
  # Log and handle the error
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
