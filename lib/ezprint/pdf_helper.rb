module Ezprint
  module PdfHelper
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
      template              = options.delete(:template) || File.join(controller_path,action_name)
      layout                = options.delete(:layout) || false
      stylesheets           = options[:stylesheets] || []
      options[:stylesheets] = stylesheets.map { |s| stylesheet_file_path(s) }

      ENV["RAILS_ASSET_ID"] = ''  # Stop Rails from appending timestamps to assets
      html_string = render_to_string(:template => template, :layout => layout)
      Ezprint.get_processor.send(:process, html_string, options)
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

      stylesheets_dir = if defined? ActionView::Helpers::AssetTagHelper::STYLESHEETS_DIR
                          ActionView::Helpers::AssetTagHelper::STYLESHEETS_DIR
                        else
                          config.stylesheets_dir
                        end
      File.join(stylesheets_dir, "#{stylesheet}.css")
    end
  end
end
