# frozen_string_literal: true

module MindmeisterApi
  # ZIP helper
  class ZipHelper
    MAX_SIZE = 50 * (1024**2)

    # Uncompress a ZIP archive that has come via string (used by HTTP request)
    #
    # @param [String] content ZIP File in string format
    def uncompress_content(content)
      content_list = MindmeisterApi::ZipContentList.new

      Zip::InputStream.open(StringIO.new(content)) do |io|
        while (entry = io.get_next_entry)
          raise 'File too large when extracted' if entry.size > MAX_SIZE

          content_list.add(entry.name, io.read)
        end
      end

      content_list
    end

    # Uncompress a ZIP archive file
    #
    # @param [String] zip_file ZIP file name
    def uncompress_file(zip_file)
      content_list = MindmeisterApi::ZipContentList.new

      Zip::File.open(zip_file) do |zip|
        zip.each do |entry|
          raise 'File too large when extracted' if entry.size > MAX_SIZE

          content_list.add(entry.name, entry.get_input_stream.read)
        end
      end

      content_list
    end
  end
end
