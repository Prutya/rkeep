# rkeep
Online keeper system.

<img width="1436" alt="screen shot 2018-04-01 at 12 38 08 am" src="https://user-images.githubusercontent.com/8135164/38167806-32a9e2c8-3545-11e8-94e0-b1c1563288ed.png">
<img width="1440" alt="screen shot 2018-04-01 at 12 30 29 am" src="https://user-images.githubusercontent.com/8135164/38167807-32c5e6d0-3545-11e8-903a-1e1d00cf46cc.png">

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

