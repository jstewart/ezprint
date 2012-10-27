module Ezprint
  module Processors
    class Prince < Base
      def self.process(html_string, options = {})
        pdf = IO.popen(self.cmd(options), "w+")
        pdf.puts(self.process_html(html_string))
        pdf.close_write
        result = pdf.gets(nil)
        pdf.close_read
        result
      end

      def self.cmd(options)
        stylesheets           = options.delete(:stylesheets)
        prince_cmd            = `which prince`.chomp

        if prince_cmd.length == 0
          raise RuntimeError.new "Cannot locate prince binary. Please check your path"
        end

        prince_cmd << " --input=html --server "
        stylesheets.each { |s| prince_cmd << " -s #{s} " }
        prince_cmd << " --silent - -o -"
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
