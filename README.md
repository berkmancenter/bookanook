[![Code Climate](https://codeclimate.com/github/berkmancenter/bookanook/badges/gpa.svg)](https://codeclimate.com/github/berkmancenter/bookanook)
[![Test Coverage](https://codeclimate.com/github/berkmancenter/bookanook/badges/coverage.svg)](https://codeclimate.com/github/berkmancenter/bookanook/coverage)
************

Book-a-Nook
=================

Description
-----------

Book-a-Nook is an online platform where a user can look up for available community spaces like libraries and make reservation requests to the admin. The admin checks for the conflicts and sends the corresponding confirmations.
Check full features and entities involved on the [wiki home page](https://github.com/berkmancenter/bookanook/wiki).

Code Repository
---------------

The code is housed in a [GitHub Repository](https://github.com/berkmancenter/bookanook).

Requirements
------------

1. Rails 4.2.5
2. RVM and Ruby >2.0.0 (tested on 2.2.1)
3. PostgreSQL (Dev, Test)

Tested Configurations
---------------------

Works well with:
1. Ubuntu 14.04 + Ruby (2.2.2) + Rails 4.2.5
2. MacOS X 10.9 + Ruby (2.2.2) + Rails 4.2.5

Setup
-----

## Setup using Docker & Docker-Compose
1. Clone the repository:

`git clone https://github.com/berkmancenter/bookanook.git`

Or clone down from your own fork of the repository.

2. Go to the application's root directory in terminal: `cd bookanook`

3. Run `cp config/social_keys.yml.sample config/social_keys.yml`. Add your own key and secret for Google authentication by setting up OAuth for your environment [here](https://cloud.google.com/ruby/getting-started/authenticate-users).

4. Create a `.env` file in the project root and populate with the preferred rails environment as follows:
```
RAILS_ENV=production
SECRET_KEY_BASE=<some key>
DEVISE_SECRET_KEY=<some key>
RAILS_SERVE_STATIC_FILES=true
```

5. Run Docker-Compose to build images: `docker-compose build`

6. Setup Docker Database: `docker-compose run app rake db:create db:migrate db:seed`

7. Run the docker images: `docker-compose up -d`

8. To stop the app: `docker-compose stop`

## Regular Setup
1. Clone the repository

`git clone https://github.com/berkmancenter/bookanook.git`

Or clone down from your own fork of the repository.

2. Go to the application's root directory in terminal: `cd bookanook`

3. If you are using RVM, create gemset for this application: `rvm gemset create bookanook`

4. Use the gemset: `rvm gemset use bookanook`

5. Install gems from Gemfile: `bundle install`

  Notes:
    * You may need to run `gem install bundle` first.
    * If you're having issues installing gems with `bundle install`, try running `bundle update` first.

6. Make necessary changes (postgresql username and password) in config/database.yml

  Here's a [resource](https://www.digitalocean.com/community/tutorials/how-to-setup-ruby-on-rails-with-postgres) to help setup a username and password for PostgreSQL on your machine.

7. Run `cp config/social_keys.yml.sample config/social_keys.yml`. Add your own key and secret for Google authentication by setting up OAuth for your environment [here](https://cloud.google.com/ruby/getting-started/authenticate-users).

8. Create database: `rake db:create`

9. Run migrations: `rake db:migrate`

10. Seed database with initial data: `rake db:seed`

11. Start the server: `rails s`

  Note: If you're having issues starting the server, try running `bundle exec rails server`.

12. Visit the application at localhost:3000

Running Tests
-------------

Tests are run using RSpec, by simply running `rspec` in your terminal.

If you receive an issue about "Web Console is activated in the test environment" that is preventing your tests from running, remove the following gem from your Gemfile:

```
gem 'web-console', '~> 2.0'
```

Then in your terminal, run the following:

```
$ gem install bundler
$ bundle install --without production
```

Issue Tracker
-------------

Please Log issues on [GitHub](https://github.com/berkmancenter/bookanook/issues).


Contributors
------------

The full list of contributors is available at [https://github.com/berkmancenter/bookanook/graphs/contributors](https://github.com/berkmancenter/bookanook/graphs/contributors)

Contributing
------------

1. Create/Pick a relevant Issue: [https://github.com/berkmancenter/bookanook/issues](https://github.com/berkmancenter/bookanook/issues)
2. Code away!
3. Send in a Pull Request.

NOTE: Will be posting a Contributing Guidelines Document soon.

Contact
-------

Contact the following people if you get stuck:
* Justin Clark  [jdcc](https://github.com/jdcc)
* Gaurav Koley  [arkokoley](https://github.com/arkokoley)
* Shubham Patel [shubhpatel108](https://github.com/shubhpatel108)

Copyright
---------

Copyright © 2017 President and Fellows of Harvard College

**************
