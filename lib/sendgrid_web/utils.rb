module SendgridWeb
  module URL
    attr_accessor :url, :params, :format, :resource, :verb

    def url
      @url ||= "#{SendgridWeb.scheme}://#{SendgridWeb.host}/"
    end
    def url_action
      parts = []
      parts << SendgridWeb.api_namespace
      parts << [resource, verb, format].join('.')
      parts.join('/')
    end
    def param(param)
      @params ||= {}
      @params.merge!(param)
    end
    def with_date
      param(:date => 1)
    end
  end
end