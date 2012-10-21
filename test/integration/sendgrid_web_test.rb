require 'test_helper'
require 'cgi'
require 'uri'
require 'sendgrid_web'

class SendgridWebTest < Test::Unit::TestCase
  def normalize_query(url)
    url.query.split('&').map{|pair| k,v = pair.split('='); {k.to_sym => CGI.unescape(v)}}
  end

  def valid_params
    {
      :api_user => 'user',
      :api_key => 'secret',
      :action => :get,
      :sg_module_name => :blocks,
      :start_date =>  '2012-07-31',
      :email => 'me@test.com',
      :format => :json,
      :from => 'other@test.com',
      :subject => 'watch it',
      :text => 'a test message'
    }
  end

  def setup
    SendgridWeb.configure do |config|
      config.api_user = valid_params[:api_user]
      config.api_key = valid_params[:api_key]
    end
  end

  def verify_url_generation(expected_url, response)
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

  def test_mail_url_generation
    expected_url = URI("https://sendgrid.com/api/mail.send.json?api_user=#{valid_params[:api_user]}&api_key=#{valid_params[:api_key]}&to=#{valid_params[:email]}&subject=#{CGI.escape(valid_params[:subject])}&from=#{valid_params[:from]}&text=#{CGI.escape(valid_params[:text])}")

    response = SendgridWeb.mail(:send, :json) do |request|
      request.param :to => valid_params[:email], :from => valid_params[:from]
      request.param :subject => valid_params[:subject]
      request.param :text => valid_params[:text]
    end

    verify_url_generation(expected_url, response)
  end

  def test_bounces_url_generation
    expected_url = URI("https://sendgrid.com/api/bounces.get.json?api_user=#{valid_params[:api_user]}&api_key=#{valid_params[:api_key]}&start_date=#{valid_params[:start_date]}&email=#{valid_params[:email]}")

    response = SendgridWeb.bounces(:get, :json) do |request|
      request.param :start_date => valid_params[:start_date]
      request.param :email => valid_params[:email]
    end

    verify_url_generation(expected_url, response)
  end


end # SendgridWebTest