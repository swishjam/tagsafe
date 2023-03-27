class AwsHelper
  class S3
    class << self
      def client
        @_client ||= Aws::S3::Client.new(region: 'us-east-1')
      end

      def get_object(bucket:, key:)
        client.get_object(bucket: bucket, key: key)
      end

      def get_object_by_s3_url(s3_url)
        get_object(bucket: url_to_bucket(s3_url), key: url_to_key(s3_url))
      end

      def delete_object_by_s3_url(s3_url)
        client.delete_object(bucket: url_to_bucket(s3_url), key: url_to_key(s3_url))
      rescue => e
        puts "CANNOT DELETE #{s3_url}: #{e.message}"
      end

      def write_to_s3(bucket:, key:, content:, acl: nil, cache_control: nil, content_type: nil, include_md5: true)
        args = { bucket: bucket, key: key, body: content }
        args[:acl] = acl unless acl.nil?
        args[:cache_control] = cache_control unless cache_control.nil?
        args[:content_type] = content_type unless content_type.nil?
        args[:content_md5] = Digest::MD5.base64digest(content) if include_md5
        client.put_object(args)
      end

      def url_to_bucket(s3_url)
        URI.parse(s3_url).hostname.split('.')[0]
      end

      def url_to_key(s3_url)
        key = URI.parse(s3_url).path
        key[0] = '' if key.starts_with?('/')
        key
      end
    end
  end

  class CloudFront
    class << self
      def client
        @_client ||= Aws::CloudFront::Client.new(region: 'us-east-1')
      end

      def invalidate_cache(*paths)
        Rails.logger.info "AwsHelper::Cloudfront -- Invaliding CloudFront cache for #{paths.join(', ')}."
        client.create_invalidation(
          distribution_id: ENV['CLOUDFRONT_CDN_DISTRIBUTION_ID'],
          invalidation_batch: {
            paths: {
              quantity: 1,
              items: paths,
            },
            caller_reference: "#{Time.current.to_i}__#{paths.join('__')}"
          }
        )
      end
    end
  end
end