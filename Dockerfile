FROM ruby:alpine

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
COPY . ./app/
