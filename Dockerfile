# syntax=docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.1

# Use the official Ruby image with version 3.2.0
FROM ruby:$RUBY_VERSION

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  nodejs \
  postgresql-client \
  libssl-dev \
  libreadline-dev \
  zlib1g-dev \
  build-essential \
  curl

# Install rbenv
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc && \
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc && \
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build && \
  echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc

# Install the specified Ruby version using rbenv
ENV PATH="/root/.rbenv/bin:/root/.rbenv/shims:$PATH"
RUN rbenv install $RUBY_VERSION && rbenv global $RUBY_VERSION

# Set the working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Install Gems dependencies
RUN gem install bundler && bundle install

# Copy the application code
COPY . /app

# Precompile assets (optional, if using Rails with assets)
RUN bundle exec rake assets:precompile

# Expose the port the app runs on
EXPOSE 3000

# Command to run the server
CMD ["./bin/dev"]
