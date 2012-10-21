require 'test_helper'
require 'cgi'
require 'uri'
require 'sendgrid_web/request'

module SendgridWeb
  def self.api_user
    'user'
  end

  def self.api_key
    'secret'
  end
end

class RequestTest < Test::Unit::TestCase
  def valid_params
    {
      :api_user => 'user',
      :api_key => 'secret',
      :action => :get,
      :sg_module_name => :blocks,
      :start_date =>  '2012-07-31',
      :email => 'me@test.com',
      :format => :json
    }
  end

  def valid_uri
    URI("https://sendgrid.com/api/#{valid_params[:sg_module_name]}.#{valid_params[:action]}.#{valid_params[:format]}").to_s
  end

  def valid_config(&block)
    SendgridWeb::Request.configure do |request|
      request.verb = valid_params[:action]
      request.resource = valid_params[:sg_module_name]
      request.format = valid_params[:format]

      yield request if  block_given?
    end
  end

  def test_request_options_returns_a_hash
    valid_config
    assert_instance_of(Hash, SendgridWeb::Request.options)
  end

  def test_request_options_returns_all_options_given
    valid_config do |request|
      request.option :timeout => 5, :open_timeout => 2
      request.option :timeout => 7
    end

    expected_options = {
      :timeout => 7,
      :open_timeout => 2
    }

    assert_equal(expected_options, SendgridWeb::Request.options)
  end

  def test_request_headers_returns_a_hash
    valid_config
    assert_instance_of(Hash, SendgridWeb::Request.headers)
  end

  def test_request_headers_returns_all_headers_given
    valid_config do |request|
      request.header :"Content-Type" => "application/json"
    end

    expected_headers = {:"Content-Type" => "application/json"}

    assert_equal(expected_headers, SendgridWeb::Request.headers)
  end
end