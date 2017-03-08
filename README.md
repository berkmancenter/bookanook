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
10. Seed database with initial data: `rake db:seed`. Check the section below for the initial test data
11. Start the server: `rails s`
12. Visit the application at localhost:3000
 
## Initial Data
The command `rake db:seed` creates 14 Nooks/Rooms and 3 Libraries and 5 users.
The users are 
```
User 1 : superadmin@bookanook.com Password:12345678
User 2 : admin1@bookanook.com     Password:12345678
User 3 : admin2@bookanook.com     Password:12345678
User 4 : admin3@bookanook.com     Password:12345678
User 5 : patron@bookanook.com     Password:12345678
```
The Libraries are
```
Library 1
Library 2
Library 3
```
The Rooms are 
```
Nice Offfice 1, Nice Office 2, Nice Office 3 ..................Nice Office 14
```