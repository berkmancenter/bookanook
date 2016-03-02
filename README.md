Book-a-Nook
======

Book a Nook is an online tool to activate community spaces, with a particular focus on libraries. It’s approach is differentiated from similar tools in the following ways: 
* Networks spaces: Supports searching across libraries / systems 
*  Data for advocacy and evaluation: Aggregates reservation data to inform space usage, advocacy, and experimentation, while respecting patrons’ privacy
*  Connection: Provides an open API so that libraries can better integrate their resources with online organizational platforms (e.g. Meetup, Eventbrite) 

It aims to expand libraries' digital presence and to deepen their integration within an online ecosystem. 

# Dependencies
1. Ruby version 2.1.2
2. Postgresql database

# Installation
1. Clone the repository using `git clone https://github.com/berkmancenter/bookanook.git` or `git clone git@github.com:berkmancenter/bookanook.git` in the terminal
2. `cd bookanook` to enter to the 'bookanook' directory
3. `bundle install` to install all the gems
4. Change the database details of your local datbase environment in the **config/databse.yml** file
5. Run `rake db:create` to create the databases
6. Then run `rake db:migrate` to migrate the tables into the databases
7. Run `rake db:seed` to populate the databases with some initial data

## Running your local instance
1. To start the server run `rails s` in your console
2. Go to **localhost:3000** in your browser
