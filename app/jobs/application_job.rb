class ApplicationJob < ActiveJob::Base
  queue_as :normal
end
