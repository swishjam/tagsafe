module TagManager
  class JsBeautifier
    def initialize(read_file:, output_file:)
      @read_file = read_file
      @output_file = output_file
    end

    def self.beautify_string!(content)
      read_file = Rails.root.join("tmp", "#{SecureRandom.hex}.js")
      opened_read_file = File.open(read_file, "w") 
      opened_read_file.puts content.force_encoding('UTF-8')
      opened_read_file.close
      beautifed_file_obj = new(
        read_file: read_file, 
        output_file: Rails.root.join("tmp", "#{SecureRandom.hex}.js")
      ).beautify!
      beautified_content = File.read(beautifed_file_obj)
      File.delete(beautifed_file_obj)
      beautified_content
    end

    def beautify!(as_file_object: true)
      if system "node node-files/js-formatter #{@read_file} #{@output_file}"
        as_file_object ? File.new(@output_file) : @output_file
      else
        raise StandardError, "js-formatted failed!"
      end
    end
  end
end