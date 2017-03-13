FROM ruby:2.2-slim

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir -p /home/code

WORKDIR /home/code

ADD Gemfile Gemfile

ADD Gemfile.lock Gemfile.lock

RUN apt-get install -y git

RUN gem install bundler --no-document

RUN bundle install

# bundle exec will be prepended to all commands

ENTRYPOINT ["bundle", "exec"]

CMD ["rails", "server", "-b", "0.0.0.0"]