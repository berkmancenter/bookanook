[![Code Climate](https://codeclimate.com/github/berkmancenter/bookanook/badges/gpa.svg)](https://codeclimate.com/github/berkmancenter/bookanook)
[![Test Coverage](https://codeclimate.com/github/berkmancenter/bookanook/badges/coverage.svg)](https://codeclimate.com/github/berkmancenter/bookanook/coverage)

## About
Book-a-Nook is an online platform where a user can look up for available community spaces like libraries and make reservation requests to the admin. The admin checks for the conflicts and sends the corresponding confirmations.
Check full features and entities involved on the [wiki home page](https://github.com/berkmancenter/bookanook/wiki).

## Specifications
1. Rails 4.2.5
2. Ruby >2.0.0 (tested on 2.2.1)
3. PostgreSQL (Dev, Test)

## Setup

1. Clone the repository

`git clone https://github.com/berkmancenter/bookanook.git`

Or clone down from your own fork of the repository.

2. Go to the application's root directory in terminal

`cd bookanook`

3. If you are using RVM, create gemset for this application: `rvm gemset create bookanook`

4. Use the gemset: `rvm gemset use bookanook`

5. Install gems from Gemfile: `bundle install`

  If you're having issues installing gems with `bundle install`, try running `bundle update` first.

6. Make necessary changes (postgresql username and password) in config/database.yml

7. Run `cp config/social_keys.yml.sample config/social_keys.yml`. Add your own key and secret for Google authentication by requesting OAuth keys [here]().

8. Create database: `rake db:create`

9. Run migrations: `rake db:migrate`

10. Seed database with initial data: `rake db:seed`

11. Start the server: `rails s`

  Note: If you're having issues starting the server, try running `bundle exec rails server`.

12. Visit the application at localhost:3000

## Running Tests
