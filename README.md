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
2. Go to the application's root directory in terminal
3. If you are using RVM, create gemset for this application: `rvm gemset create bookanook`
4. Use the gemset: `rvm gemset use bookanook`
5. Install gems from Gemfile: `bundle install`
6. Make necessary changes (postgresql username and password) in config/database.yml
7. Run `cp config/social_keys.yml.sample config/social_keys.yml`. Add key and secret for Google authentication.
8. Create database: `rake db:create`
9. Run migrations: `rake db:migrate`
10. Seed database with initial data: `rake db:seed`
11. Start the server: `rails s`
12. Visit the application at localhost:3000

## Dockerized Setup

1. Install `Docker` and `docker-compose`
2. Clone the repository
3. Go to the application's root directory in terminal
4. Run `cp config/social_keys.yml.sample config/social_keys.yml`. Add key and secret for Google authentication
5. Add `host: db` and `username: postgres` to `database.yml` (Have a look at `database.yml.docker`)
6. Run `docker-compose build`
7. Run `docker-compose up`
8. Create database:  `docker-compose run bookanook rake db:create`
9. Run migrations: `docker-compose run bookanook rake db:migrate`
10. Seed database with initial data: `docker-compose run bookanook rake db:seed`
11. Visit the application at localhost:3000
