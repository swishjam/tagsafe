web: bundle exec rails server
worker: INTERVAL=0.1 QUEUE=critical,normal,low,default bundle exec rake resque:work
resque_scheduler: bundle exec rake resque:scheduler

# dev_worker: INTERVAL=0.1 QUEUE=critical,normal,low,default bundle exec rake resque:work