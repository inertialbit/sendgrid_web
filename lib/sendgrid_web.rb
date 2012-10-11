require "sendgrid_web/version"
require "sendgrid_web/request"

module SendgridWeb

  def self.get resource, format=:json, &builder
    Request.new do |request|
      request.verb = :get
      request.resource = resource
      request.format = format

      yield request
    end
  end

  class << self
    attr_accessor :host, :scheme, :api_namespace, :api_user, :api_key

    def configure
      yield self
    end
  end
end

SendgridWeb.configure do |config|
  config.scheme = "https"
  config.host = "sendgrid.com"
  config.api_namespace = "api"
end
