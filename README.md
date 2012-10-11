# SendgridWeb

Ruby interface for working with SendGrid's Web (HTTP) API. Read more at http://docs.sendgrid.com/documentation/api/web-api/.

## Installation

Add this line to your application's Gemfile:

    gem 'sendgrid_web'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sendgrid_web

## Usage

I think something like the following would be nice.

### Configuration

For global situations:

    SendgridWeb.configure do |config|
      config.api_user = 'sendgrid-user'
      config.api_key = 'sendgrid-secret'
    end

And per instance:

    SendgridWeb.configure :api_user => 'sendgrid-user', :api_key => 'sendgrid-secret'

### Running Programmatically

Bounces/Unsubscribes API components

    params = {
      :date => 1, # can only be set to 1 and if so then retrieves timestamp of bounced records
      :days => 30, # number of days into past to retrieve records for (includes today)
      :start_date => 2012-07-01, # look for records more recent than this date
      :end_date => 2012-07-31, # look for records older than this date
      :limit => 20,
      :offset => 0,
      :type => 'hard' or 'soft', # type of bounce to search for
      :email => 'blah@test.com', # email address to search for
    }

    SendgridWeb::Bounces.get(params)
    SendgridWeb::Bounces.delete(params)
    SendgridWeb::Bounces.count(params)

    SendgridWeb::Unsubscribes.get(params)
    SendgridWeb::Unsubscribes.add(params)
    SendgridWeb::Unsubscribes.delete(params)

or

    SendgridWeb::Bounces.get.date!.days(30).after(2012-07-01).before(2012-07-31).limit(20).offset(0).type('hard').email('blah@test.com')
    SendgridWeb::Bounces.delete.after(2012-07-01).before(2012-07-31).type('hard').email('blah@test.com')
    SendgridWeb::Bounces.count.after(2012-07-01).before(2012-07-31).type('hard')

    SendgridWeb::Unsubscribes.get.date!.days(30).after(2012-07-01).before(2012-07-31).limit(20).offset(0).email('blah@test.com')
    SendgridWeb::Unsubscribes.delete.after(2012-07-01).before(2012-07-31).email('blah@test.com')
    SendgridWeb::Unsubscribes.add.email('blah@test.com')

### Running Manually

    $ sendgrid_web get unsubscribes --with-date --days-ago 30 --after 2012-07-01 --before 2012-07-31 --limit 20 --offset 0 --email 'blah@test.com'
    $ sendgrid_web delete unsubscribes --email 'blah@test.com'
    $ sendgrid_web delete unsubscribes --after 2012-07-01 --before 2012-07-31
    $ sendgrid_web get bounces --with-date --days-ago 30

## Swapping HTTP libs

Would be nice to have ability to transparently swap HTTP lib.

    SendgridWeb.configure do |config|
      config.http_library = :boss
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
