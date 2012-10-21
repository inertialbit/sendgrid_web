require 'test_helper'
require 'cgi'
require 'uri'
require 'sendgrid_web/utils'

module FakeRequest
  extend SendgridWeb::URL
end

module SendgridWeb
  def self.scheme
    'https'
  end

  def self.host
    'sendgrid.com'
  end

  def self.api_namespace
    'api'
  end
end

class UtilsTest < Test::Unit::TestCase
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
    FakeRequest.verb = valid_params[:action]
    FakeRequest.resource = valid_params[:sg_module_name]
    FakeRequest.format = valid_params[:format]

    yield FakeRequest if  block_given?
  end

  def test_uri_returns_a_string
    valid_config
    assert_instance_of(String, FakeRequest.uri)
  end

  def test_uri_returns_fully_built_uri
    valid_config
    assert_equal(valid_uri, FakeRequest.uri)
  end

  def test_url_returns_a_string
    valid_config
    assert_instance_of(String, FakeRequest.url)
  end

  def test_params_returns_a_hash
    valid_config
    assert_instance_of(Hash, FakeRequest.params)
  end

  def test_params_returns_all_params_given
    valid_config do |request|
      request.param :api_user => valid_params[:api_user], :api_key => valid_params[:api_key]
      request.param :email => valid_params[:email]
    end

    expected_params = {
      :api_user => valid_params[:api_user],
      :api_key => valid_params[:api_key],
      :email => valid_params[:email]
    }

    assert_equal(expected_params, FakeRequest.params)
  end

end