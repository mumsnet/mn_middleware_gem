FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir -p /mn_middleware_gem/lib/mn_middleware_gem
WORKDIR /mn_middleware_gem
COPY mn_middleware_gem.gemspec /mn_middleware_gem/mn_middleware_gem.gemspec
COPY Gemfile /mn_middleware_gem/Gemfile
COPY Gemfile.lock /mn_middleware_gem/Gemfile.lock
COPY lib/mn_middleware_gem/version.rb /mn_middleware_gem/lib/mn_middleware_gem
RUN bundle install
COPY . /mn_middleware_gem
