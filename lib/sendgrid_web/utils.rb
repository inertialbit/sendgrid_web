module SendgridWeb
  ##
  #
  # Assembles a URL for Sendgrid.
  #
  module URL
    attr_accessor :format, :resource, :verb

    def uri
      URI.join(url, url_action).to_s
    end

    def url
      @url ||= "#{SendgridWeb.scheme}://#{SendgridWeb.host}/"
    end

    def params
      @params ||= {}
    end

    # Returns action portion of Sendgrid URL, e.g.
    # "api/resource.verb.format"
    def url_action
      parts = []
      parts << SendgridWeb.api_namespace
      parts << [resource, verb, format].join('.')
      parts.join('/')
    end

    # Add or overwrite a param in +@params+ hash.
    # These are passed through to Faraday.
    def param(param)
      params.merge!(param)
    end

    # Convenience method to add param with
    # strict Sendgrid requirements.
    def with_date
      param(:date => 1)
    end
  end
end