require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "ezprint"
    gem.summary = %Q{A Rails wrapper for the PDFkit library. Meant to be a drop in replacement for princely.}
    gem.description = %Q{A Rails wrapper for the PDFkit library. Meant to be a drop in replacement for princely.}
    gem.email = "jstewart@fusionary.com"
    gem.homepage = "http://github.com/jstewart/ezprint"
    gem.authors = ["Jason Stewart"]
    gem.add_dependency 'pdfkit', '~> 0.5.0'
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ezprint #{version}"
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
