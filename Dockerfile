FROM ruby:2.3.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /adhoc

WORKDIR /adhoc

COPY Gemfile /adhoc/Gemfile
COPY Gemfile.lock /adhoc/Gemfile.lock

RUN bundle install

COPY . /adhoc