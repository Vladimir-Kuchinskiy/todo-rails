FROM ruby:alpine

RUN apk add --update build-base postgresql-dev tzdata
RUN gem install rails

WORKDIR /app
COPY Gemfile* ./
RUN bundle install
COPY . .
