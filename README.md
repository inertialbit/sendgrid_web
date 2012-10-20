# SendgridWeb

Ruby interface for working with SendGrid's Web (HTTP) API. Read more at http://docs.sendgrid.com/documentation/api/web-api/.

## Build Status [<img src="https://secure.travis-ci.org/inertialbit/sendgrid_web.png"/>](http://travis-ci.org/inertialbit/sendgrid_web)

## Installation

Add this line to your application's Gemfile:

    gem 'sendgrid_web'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sendgrid_web

## Usage

Something like the following would be nice.

### Configuration

    SendgridWeb.configure do |config|
      config.api_user = 'sendgrid-user'
      config.api_key = 'sendgrid-secret'
    end

### Running Programmatically

    response = SendgridWeb.unsubscribes(:get, :xml) do |request|
      request.option :timeout => 30
      request.option :open_timeout => 30
      request.header 'HTTP-HEADER' => 'value'

      request.with_date # special to enforce api rule of required value of 1

      request.param 'start_date' => 2012-07-31
      request.param 'email' => 'me@test.com'
    end

    if response.success?
      # do stuff...
    else
      # do other stuff...
    end

### Running Manually

not implemented yet!!

    $ sendgrid_web get unsubscribes --with-date --days 30 --start_date 2012-07-01 --end_date 2012-07-31 --limit 20 --offset 0 --email 'blah@test.com'
    $ sendgrid_web delete unsubscribes.xml --email 'blah@test.com'
    $ sendgrid_web delete unsubscribes.json --after 2012-07-01 --before 2012-07-31
    $ sendgrid_web get bounces --with-date --days-ago 30 # default is json

## Todo

- more tests
- implement as Faraday middleware (support async calls)
- CLI

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
