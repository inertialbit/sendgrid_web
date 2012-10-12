require 'sendgrid_web/utils'

begin
  require 'faraday'
rescue LoadError => e
  require 'rubygems'
  require 'faraday'
  p "Warning: requiring rubygems since faraday failed to load on it's own."
end

module SendgridWeb
  module Request
    class << self
      attr_accessor :headers, :options, :callbacks
      include URL

      def configure &block
        @callbacks = {}
        @headers = []
        @options = []

        unless SendgridWeb.api_user.nil? or SendgridWeb.api_key.nil?
          param(:api_user => SendgridWeb.api_user)
          param(:api_key => SendgridWeb.api_key)
        end

        yield self
      end

      def option(option)
        @options ||= {}
        @options.merge!(option)
      end

      def header(header)
        @headers ||= {}
        @headers.merge!(header)
      end
    end
  end
end
