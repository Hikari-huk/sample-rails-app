FROM ruby:3.4.6

ARG APP_ROOT='/usr/src/sample-rails-app'

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs
RUN apt-get install -y vim

WORKDIR $APP_ROOT

COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock
RUN bundle install

COPY . $APP_ROOT