require 'pdfkit'

module Ezprint
  module Processors
    class Pdfkit < Base
      def self.process(html_string, options = {})
        stylesheets = options.delete(:stylesheets)
        kit = PDFKit.new(self.process_html(html_string), options)
        kit.stylesheets = stylesheets
        kit.to_pdf
      end

      def self.process_html(html)
        # reroute absolute paths
        html.gsub!("src=\"/", "src=\"#{Rails.public_path}/")
        html.gsub!("href=\"/", "src=\"#{Rails.public_path}/")
        html.gsub!("url(/", "url(#{Rails.public_path}/")
        html
      end
    end
  end
end
