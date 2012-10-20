require 'test_helper'
require 'cgi'
require 'uri'
require 'sendgrid_web'

class SendgridWebTest < Test::Unit::TestCase
  def self.sendgrid_modules
    [
      {:bounces => [:get, :delete]},
      {:blocks => [:get, :delete]},
      {:parse => [:get, :set, :edit, :delete]},
      {:filter => [:get, :activate, :deactivate, :setup, :getsettings]},
      {:invalidemails => [:get, :delete]},
      {:mail => [:send]},
      {:profile => [:get, :set, :setUsername, :setPassword, :setEmail]},
      {:spamreports => [:get, :delete]},
      {:stats => [:get]},
      {:unsubscribes => [:add, :get, :delete]}
    ]
  end

  def normalize_query(url)
    url.query.split('&').map{|pair| k,v = pair.split('='); {k.to_sym => CGI.unescape(v)}}
  end

  sendgrid_modules.each do |sg_module|
    define_method "test_#{sg_module}_wrapper" do
      sg_module.each do |sg_module_name, sg_module_actions|
        sg_module_actions.each do |action|

          email = 'me@test.com'
          start_date = '2012-07-31'
          api_user = 'user'
          api_key = 'secret'
          expected_url = URI("https://sendgrid.com/api/#{sg_module_name}.#{action}.json?api_user=#{api_user}&api_key=#{api_key}&start_date=#{start_date}&email=#{email}")

          SendgridWeb.configure do |config|
            config.api_user = api_user
            config.api_key = api_key
          end

          response = SendgridWeb.send(sg_module_name, action, :json) do |request|
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

        end # sg_module_actions#each
      end # sg_module#each
    end # define_method
  end # sendgrid_modules#each
end # SendgridWebTest