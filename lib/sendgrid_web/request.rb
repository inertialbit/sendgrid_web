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
      include URL

      ##
      #
      # Configure a Request. +@options+ and +@headers+ are
      # passed through to Faraday, as are +@params+ provided by +URL+.
      #
      def configure &block
        unless SendgridWeb.api_user.nil? or SendgridWeb.api_key.nil?
          param(:api_user => SendgridWeb.api_user)
          param(:api_key => SendgridWeb.api_key)
        end

        yield self
      end

      def option(option)
        options.merge!(option)
      end

      def options
        @options ||= {}
      end

      def header(header)
        headers.merge!(header)
      end

      def headers
        @headers ||= {}
      end
    end
  end
end
