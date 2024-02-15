ARG RUBY_VERSION=3.0.1
ARG DISTRO_NAME=buster
ARG NODE_MAJOR=14
ARG BUNDLE_VERSION=2.2.15

FROM ruby:$RUBY_VERSION-slim-$DISTRO_NAME as base

# base install
RUN apt-get update -yqq && \
    apt-get install -yqq --no-install-recommends \
    gnupg \
    git \
    curl \
    build-essential \
    libpq-dev \
    nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=true apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

WORKDIR /app

FROM base as build

# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN curl -sS https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
# RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" | tee  /etc/apt/sources.list.d/pgdg.list

RUN apt-get install -yqq --no-install-recommends \
    postgresql-client \
    yarn

#ENV TZ=Asia/Jakarta
RUN gem install bundler

COPY Gemfile .

RUN bundle install

COPY . .

