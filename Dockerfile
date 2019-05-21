FROM ruby:2.6.1-alpine3.9

RUN apk update \
  && apk add --virtual build-dependencies \
  imagemagick \
  gcc \
  wget \
  git \
  && apk add \
  build-base postgresql-dev tzdata \
  bash

RUN gem install rails

WORKDIR /app
COPY Gemfile* ./
RUN bundle install
COPY . .
CMD ["rails", "s"]
