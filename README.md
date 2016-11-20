# rkeep
Online keeper system.

Create test and development databases
~~~~
$ createdb -Eunicode rkeep_dev
$ createdb -Eunicode rkeep_test
~~~~

Install the needed gems:
~~~~
$ bundle install
~~~~

Apply database migrations
~~~~
$ rails db:migrate
~~~~

Seed initial data
~~~~
$ rails db:seed
~~~~

Run test suite
~~~~
$ bundle exec rspec
~~~~

If the test suite passes, you'll be ready to run the app in a local server:
~~~~
$ rails server
~~~~
