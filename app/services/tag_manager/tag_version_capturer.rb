module TagManager
  class TagVersionCapturer
    def initialize(tag:, content:)
      @tag = tag
      @original_content = content
      
      @minifier = JsMinifier.new(@original_content)
      @minifier.minified_content
    end

    def capture_new_tag_version!
      tag_version = @tag.tag_versions.create!(tag_version_data)
      upload_files_to_s3!(tag_version)
      @tag.update!(currently_live_tag_version: tag_version)
      remove_temp_files
      tag_version
    end

    private

    def tag_version_data
      {
        original_content_host_url: "https://#{ENV['HOST_CDN_HOSTNAME']}/#{generated_s3_key('original')}",
        minified_content_host_url: @minifier.minified_successfully? ? "https://#{ENV['HOST_CDN_HOSTNAME']}/#{generated_s3_key('minified')}" : nil,
        hashed_content: hashed_content,
        sha_256: OpenSSL::Digest.new('SHA256').base64digest( File.read(js_file) ), # needs to read from the file? not from in memory?
        original_content_byte_size: @original_content.bytesize,
        minified_byte_size: @minifier.minified_successfully? ? @minifier.minified_content.bytesize : -1,
      }
    end

    def upload_files_to_s3!(tag_version)
      upload_to_s3!(@original_content, generated_s3_key('original'))
      upload_to_s3!(File.read(js_file), generated_s3_key('minified'))
    end

    def upload_to_s3!(content, key)
      AwsHelper::S3.write_to_s3(
        bucket: ENV['HOSTED_CONTENT_S3_BUCKET_NAME'],
        key: key,
        content: content,
        cache_control: 'public, immutable, max-age=31536000, stale-while-revalidate=86400', # cache for 1 year
        acl: 'public-read',
        content_type: 'text/javascript'
      )
    end

    def generated_s3_key(suffix)
      "#{@tag.organization.unique_key}/tags/#{@tag.hostname_and_path.gsub(/[^a-zA-Z0-9]/, '_')}_#{hashed_content}_#{suffix}.js"
    end

    def hashed_content
      @hashed_content ||= Digest::MD5.hexdigest(@original_content)
    end

    def js_file
      return @js_file if @js_file
      @js_file = File.open(local_file_location(:compiled), "w") 
      @js_file.puts @minifier.minified_content.force_encoding('UTF-8')
      @js_file.close
      @js_file
    end
    
    def local_file_location(suffix)
      Rails.root.join('tmp', "#{@tag.id.to_s}-#{Digest::MD5.hexdigest(@original_content)}-#{suffix}.js")
    end
    
    def remove_temp_files
      File.delete(local_file_location(:compiled))
    end
  end
end