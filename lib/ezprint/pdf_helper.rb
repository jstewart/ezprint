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
      stylesheets = options.delete(:stylesheets) || []
      layout = options.delete(:layout) || false
      template = options.delete(:template) || File.join(controller_path,action_name)

      # Stop Rails from appending timestamps to assets.
      ENV["RAILS_ASSET_ID"] = ''
      html_string = render_to_string(:template => template, :layout => layout)

      kit = PDFKit.new(process_html_string(html_string), options)
      kit.stylesheets = stylesheets.collect{ |style| stylesheet_file_path(style) }

      kit.to_pdf
    end

    def make_and_send_pdf(pdf_name, options = {})
      filename = "#{pdf_name}.pdf"
      if request.headers['User-Agent'] =~ /MSIE ([0-9]{1,}[\.0-9]{0,})/
        response.headers['Content-Disposition'] = "attachment;filename=\"#{filename}.pdf\""
        response.headers['Content-Description'] = 'File Transfer'
        response.headers['Content-Transfer-Encoding'] = 'binary'
        response.headers['Expires'] = '0'
        response.headers['Pragma'] = 'public'
      end

      send_data(
                make_pdf(options),
                :filename => filename,
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
