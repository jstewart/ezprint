require 'active_support/inflector'

module Ezprint
  autoload :PdfHelper, 'ezprint/pdf_helper'

  module Processors
    autoload :Base, 'ezprint/processors/base'
    autoload :Pdfkit, 'ezprint/processors/pdfkit'
    autoload :Prince, 'ezprint/processors/prince'
  end

  @@processor = :pdfkit
  mattr_accessor :processor

  def self.get_processor
    ::Ezprint::Processors.const_get(Ezprint.processor.to_s.classify)
  end
end

if defined?(::Rails::Railtie)
  require 'ezprint/railtie'
else
  # Rails 2.x
  Mime::Type.register 'application/pdf', :pdf
  ActionController::Base.send(:include, Ezprint::PdfHelper)
end
