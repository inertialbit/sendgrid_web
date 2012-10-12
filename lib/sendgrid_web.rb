require "sendgrid_web/version"
require "sendgrid_web/request"

module SendgridWeb

  Faraday.register_middleware :request, :api => lambda { API }

  def self.get resource, format=:json, &block
    Request.configure do |request|
      request.verb = :get
      request.resource = resource
      request.format = format

      yield request
    end
    process
  end

  def self.delete resource, format=:json, &block
    Request.configure do |request|
      request.verb = :delete
      request.resource = resource
      request.format = format

      yield request
    end
    process
  end

  def self.process
    url = URI.join(Request.url, Request.url_action).to_s
    Faraday.get(url, Request.params, Request.headers)
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
