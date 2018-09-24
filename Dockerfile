FROM ruby:2.5.1-alpine3.7

RUN apk add --update \
  build-base \
  libxml2-dev \
  libxslt-dev \
  postgresql-dev \
  nodejs \
  && rm -rf /var/cache/apk/*

ENV APP_HOME /src
ENV RAILS_ENV production
ENV SECRET_KEY_BASE temp

COPY . $APP_HOME
WORKDIR $APP_HOME

RUN bundle install --without development test \
  && rails assets:precompile

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
