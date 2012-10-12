require 'test_helper'
require 'cgi'
require 'uri'
require 'sendgrid_web'

class SendgridWebTest < Test::Unit::TestCase
  def normalize_query(url)
    url.query.split('&').map{|pair| k,v = pair.split('='); {k.to_sym => CGI.unescape(v)}}
  end
  def test_get_interface
    email = 'me@test.com'
    start_date = '2012-07-31'
    expected_url = URI("https://sendgrid.com/api/unsubscribes.get.json?api_user=user&api_key=secret&start_date=#{start_date}&email=#{email}")

    SendgridWeb.configure do |config|
      config.api_user = 'user'
      config.api_key = 'secret'
    end

    response = SendgridWeb.get(:unsubscribes, :json) do |request|
      request.with_date # special to enforce api rule of required value of 1

      request.param :start_date => start_date
      request.param :email => email
    end

    generated_url = response.env[:url]

    %w(scheme host path).each do |part|
      assert_equal(expected_url.send(part), generated_url.send(part), "generated #{part} didn't match expected")
    end

    generated_query = normalize_query(generated_url)
    expected_query = normalize_query(expected_url)

    expected_query.each do |param|
      assert(generated_query.include?(param), "generated query missing #{param.inspect}")
    end
  end

  def test_delete_interface
    email = 'me@test.com'
    expected_url = URI("https://sendgrid.com/api/unsubscribes.delete.json?api_user=user&api_key=secret&email=#{email}")

    SendgridWeb.configure do |config|
      config.api_user = 'user'
      config.api_key = 'secret'
    end

    response = SendgridWeb.delete(:unsubscribes, :json) do |request|
      request.param :email => email
    end

    generated_url = response.env[:url]

    %w(scheme host path).each do |part|
      assert_equal(expected_url.send(part), generated_url.send(part), "generated #{part} didn't match expected")
    end

    generated_query = normalize_query(generated_url)
    expected_query = normalize_query(expected_url)

    expected_query.each do |param|
      assert(generated_query.include?(param), "generated query missing #{param.inspect}")
    end
  end
end