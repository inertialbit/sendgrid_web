# run tests
begin
  require 'rake/testtask'
rescue LoadError => e
end

if defined? Rake::TestTask
  namespace :test do
    SENDGRID_WEB_ROOT = File.expand_path(File.join(File.dirname(__FILE__), "..",".."))
    Rake::TestTask.new(:sendgrid_web) do |t|
      t.libs << "#{SENDGRID_WEB_ROOT}/test"
      t.libs << "#{SENDGRID_WEB_ROOT}/lib"
      t.pattern = "#{SENDGRID_WEB_ROOT}/test/**/*_test.rb"
      t.verbose = true
    end
    Rake::Task['test:sendgrid_web'].comment = "Run the tests for SendgridWeb."
    # task :sendgrid_web => :environment
  end
end
