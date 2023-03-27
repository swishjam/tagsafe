module ConfigurationManager
  class Publisher
    def initialize(organization)
      @organization = organization
    end

    def publish_current_configuration_to_cdn
      aws_handler.write_organizations_config_to_s3(config_generator.json_config)
      aws_handler.purge_organizations_instrumentation_cloudfront_cache
    end

    private

    def config_generator
      @config_generator ||= ConfigGenerator.new(@organization)
    end

    def aws_handler
      @aws_handler ||= AwsHandler.new(@organization)
    end
  end
end