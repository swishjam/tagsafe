module ConfigurationManager
  class AwsHandler
    def initialize(organization)
      @organization = organization
    end

    def write_organizations_config_to_s3(config_content, cache_seconds: 5 * 60)
      AwsHelper::S3.write_to_s3(
        bucket: ENV['HOSTED_CONTENT_S3_BUCKET_NAME'], 
        key: @organization.hosted_configuration_pathname.slice(1..-1), 
        content: config_content,
        cache_control: "public, max-age=#{cache_seconds}, stale-while-revalidate=60",
        acl: 'public-read',
        content_type: 'text/javascript'
      )
    end

    def purge_organizations_instrumentation_cloudfront_cache
      AwsHelper::CloudFront.invalidate_cache(@organization.hosted_configuration_pathname)
    end
  end
end