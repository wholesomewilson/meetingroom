FROM ruby:2.6.6

RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
    postgresql-client \
    nodejs \
    nano \
  && apt-get -q clean \
  && rm -rf /var/lib/apt/lists

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
COPY . .

# Pre-compile assets
ENV RAILS_ENV production
RUN rails assets:precompile

CMD script/start
