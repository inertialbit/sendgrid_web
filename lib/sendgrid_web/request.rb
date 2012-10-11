require 'sendgrid_web/utils'

begin
  require 'faraday'
rescue LoadError => e
  require 'rubygems'
  require 'faraday'
  p "Warning: requiring rubygems since faraday failed to load on it's own."
end

module SendgridWeb
  ##
  #
  # This class interfaces with Faraday.
  # It will pass a URL to that client library constructed from provided
  # params and config options.
  #
  class Request
    attr_accessor :headers, :options
    include URL

    def initialize &block
      @callbacks = {}
      @headers = []
      @options = []

      unless SendgridWeb.api_user.nil? or SendgridWeb.api_key.nil?
        param(:api_user => SendgridWeb.api_user)
        param(:api_key => SendgridWeb.api_key)
      end

      yield self

      process
    end

    def option(option)
      @options << option
    end

    def header(header)
      @headers << header
    end

    def transfer_settings(hashes)
      hashes.each do |hash|
        hash.each do |k,v|
          yield k.to_s, v
        end
      end
    end

    def process
      connection = Faraday.new url do |faraday|
        transfer_settings(options) { |k,v| faraday.options[k] = v }
      end

      @response = connection.get("/#{url_action}") do |request|
        transfer_settings(params) { |k,v| request.params[k] = v }
        transfer_settings(headers) { |k,v| request.headers[k] = v }
      end

      run_callbacks :on_complete

      @response
    end

    def on_complete &block
      @callbacks[:on_complete] ||= []
      @callbacks[:on_complete] << block
    end

    def run_callbacks signature
      @callbacks[signature].each do |callback|
        callback.call @response
      end
    end
  end
end
