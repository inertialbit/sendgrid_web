require "sendgrid_web/version"
require "sendgrid_web/request"

##
#
# Module to provide thin ruby API to SendGrid Web API.
# Uses Faraday to make requests. Currently supports synchronous calls only.
#
# Exposes both Sendgrid and Faraday interfaces.
#
module SendgridWeb

  ##
  #
  # Primary interface. Simply call the desired module directly on SendgridWeb
  # and pass in the verb, format and a block to set any needed parameters.
  #
  # Example usage:
  #
  #     # Make a request to SendGrid module, say Unsubscribes
  #     # fetching a specific email.
  #     faraday_response = SendgridWeb.unsubscribes(:get, :json) { request.param :email => 'me@test.com' }
  #
  #     # Send an email.
  #     faraday_response = SendgridWeb.mail(:send, :xml) do
  #       request.param :to => 'me@test.com', :subject => 'Tada!', :from => 'you@test.com'
  #       request.param :text => 'sample message body'
  #       request.param :html => '<p>sample message body</p>'
  #     end
  #
  def self.method_missing(resource, verb, format=:json, &block)
    Request.configure do |request|
      request.verb = verb
      request.resource = resource
      request.format = format

      yield request
    end
    process
  end

  class << self
    attr_accessor :host, :scheme, :api_namespace, :api_user, :api_key

    def configure
      yield self
    end
  end

private

  def self.process
    url = URI.join(Request.url, Request.url_action).to_s
    Faraday.get(url, Request.params, Request.headers)
  end
end

SendgridWeb.configure do |config|
  config.scheme = "https"
  config.host = "sendgrid.com"
  config.api_namespace = "api"
end
