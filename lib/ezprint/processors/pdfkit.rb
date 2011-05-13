require 'pdfkit'

module Ezprint
  module Processors
    class Pdfkit
      def self.process(html_string, options = {})
        stylesheets = options.delete(:stylesheets)
        kit = PDFKit.new(self.process_html(html_string), options)
        kit.stylesheets = stylesheets
        kit.to_pdf
      end

      def self.process_html(html)
        # reroute absolute paths
        html.gsub!("src=\"/", "src=\"#{RAILS_ROOT}/public/")
        html.gsub!("href=\"/", "src=\"#{RAILS_ROOT}/public/")
        html.gsub!("url(/", "url(#{RAILS_ROOT}/public/")
        html
      end
    end
  end
end
