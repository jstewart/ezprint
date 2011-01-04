require 'ezprint/pdf_helper'

if defined?(::Rails::Railtie)
  require 'ezprint/railtie'
else
  # Rails 2.x
  Mime::Type.register 'application/pdf', :pdf
  ActionController::Base.send(:include, PdfHelper)
end
