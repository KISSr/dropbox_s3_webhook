web: bundle exec rails server thin -p $PORT -e $RACK_ENV
resque: QUEUE=* bundle exec rake resque:work
