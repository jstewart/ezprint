# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ezprint}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jason Stewart"]
  s.date = %q{2012-10-27}
  s.description = %q{A Rails wrapper for the PDFkit library. Meant to be a drop in replacement for princely.}
  s.email = %q{jstewart@fusionary.com}
  s.extra_rdoc_files = [
    "README",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "MIT-LICENSE",
    "README",
    "README.rdoc",
    "VERSION",
    "ezprint.gemspec",
    "init.rb",
    "lib/ezprint.rb",
    "lib/ezprint/pdf_helper.rb",
    "lib/ezprint/processors/base.rb",
    "lib/ezprint/processors/pdfkit.rb",
    "lib/ezprint/processors/prince.rb",
    "lib/ezprint/railtie.rb"
  ]
  s.homepage = %q{http://github.com/jstewart/ezprint}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.1}
  s.summary = %q{A Rails wrapper for the PDFkit library. Meant to be a drop in replacement for princely.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<pdfkit>, ["~> 0.5.0"])
    else
      s.add_dependency(%q<pdfkit>, ["~> 0.5.0"])
    end
  else
    s.add_dependency(%q<pdfkit>, ["~> 0.5.0"])
  end
end

