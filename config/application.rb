require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tagsafe
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.time_zone = "Pacific Time (US & Canada)"

    config.active_job.queue_adapter = :resque
    # config.active_record.raise_in_transactional_callbacks = true
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Load decorators as late as possible so models being extended already autoloaded     
    # %w[ decorators ].each do |dir|       
    #   config.to_prepare do         
    #     Dir.glob(File.join(Rails.root, 'app', dir, '**/*_decorator.rb')).each { |c| require_dependency(c) }       
    #   end
    # end
    
    # load nested models
    # need to run bin/spring stop when adding new nested model to reset the cache
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{*/}')]

    config.active_storage.analyzers = []
    config.active_storage.previewers = []
  end
end
