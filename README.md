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


## Initial Data
`rake db:seed`, Seeds the database with some Users, Libraries and Nooks.
The users are
```
         Email-ID                      Role           Password
User 1 : superadmin@bookanook.com      SuperAdmin     Password:12345678
User 2 : admin1@bookanook.com          Admin          Password:12345678
User 3 : admin2@bookanook.com          Admin          Password:12345678
User 4 : admin3@bookanook.com          Admin          Password:12345678
User 5 : patron@bookanook.com          Patron         Password:12345678
```
The Libraries are
```
Library 1
Library 2
Library 3
```
The Rooms are
```
Library 1: Nice Office 1, Nice Office 3, Nice Office 5, Nice Office 6, Nice Office 10, Nice Office 13
Library 2: Nice Office 2, Nice Office 7, Nice Office 9, Nice Office 12
Library 3: Nice Office 4, Nice Office 8, Nice Office 11, Nice Office 14
```

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
