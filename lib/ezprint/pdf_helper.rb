module EzPrint
  module PdfHelper
    require 'pdfkit'

    def self.included(base)
      base.class_eval do
        alias_method_chain :render, :ezprint
      end
    end
    
    def render_with_ezprint(options = nil, *args, &block)
      if options.is_a?(Symbol) or options.nil? or options[:pdf].nil?
        render_without_ezprint(options, *args, &block)
      else
        options[:name] ||= options.delete(:pdf)
        make_and_send_pdf(options.delete(:name), options)
      end
    end

    private

    def make_pdf(options = {})
      options[:stylesheets] ||= []
      options[:layout] ||= false
      options[:template] ||= File.join(controller_path,action_name)

      # Stop Rails from appending timestamps to assets.
      ENV["RAILS_ASSET_ID"] = ''
      html_string = render_to_string(:template => options[:template], :layout => options[:layout])

      kit = PDFKit.new(process_html_string(html_string))
      kit.stylesheets = options[:stylesheets].collect{ |style| stylesheet_file_path(style) }

      kit.to_pdf
    end

    def make_and_send_pdf(pdf_name, options = {})
      send_data(
                make_pdf(options),
                :filename => pdf_name + ".pdf",
                :type => 'application/pdf'
                )
    end

    def stylesheet_file_path(stylesheet)
      stylesheet = stylesheet.to_s.gsub(".css","")
      File.join(ActionView::Helpers::AssetTagHelper::STYLESHEETS_DIR,"#{stylesheet}.css")
    end

    def process_html_string(html)
      # reroute absolute paths
      html.gsub!("src=\"/", "src=\"#{RAILS_ROOT}/public/")
      html.gsub!("href=\"/", "src=\"#{RAILS_ROOT}/public/")
      html.gsub!("url(/", "url(#{RAILS_ROOT}/public/")
      html
    end
  end
end
