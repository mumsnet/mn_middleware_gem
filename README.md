# MnMiddlewareGem

This gem provides some middleware for Mumsnet microservices.

`CorrelationId` checks https headers for the Amazon load balancer trace id and 
sets that as the request ID in rails if available.  It also then ensures that
request ID is included in every outgoing http call to other microservices so that
the history of a request through all our systems can be traced easily.

`RemoteIpLogger` sets the correct remote IP in rails even when the request
came via proxies or load balancers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mn_middleware_gem'
```

## Usage

Add the following 2 lines near the top of your `Rails.application.configure do` block 
in both `production.rb` and `development.rb`:

```ruby
  config.middleware.insert_after Rack::Runtime, MnMiddleware::CorrelationId
  config.middleware.insert_before Rails::Rack::Logger, MnMiddleware::RemoteIpLogger
```

## Development

Run `./build_gem.sh` to build this gem, run the rspec tests and get instructions on
how to push it to rubygems.org