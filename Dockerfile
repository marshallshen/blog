# FROM ruby:2.6.2
# WORKDIR /app
# ADD . /app

# RUN gem install bundler
# RUN bundle install

# RUN ["irb"]

FROM node:18

# Install Ruby 3.2 dependencies
RUN apt-get update && apt-get install -y \
    wget \
    build-essential \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev

# Download and install Ruby 3.2
RUN wget https://cache.ruby-lang.org/pub/ruby/3.2/ruby-3.2.0.tar.gz && \
    tar -xzvf ruby-3.2.0.tar.gz && \
    cd ruby-3.2.0 && \
    ./configure && \
    make && \
    make install

# Clean up downloaded files
RUN rm -rf ruby-3.2.0 ruby-3.2.0.tar.gz

WORKDIR /app
ADD . /app

RUN gem install bundler
RUN bundle install

RUN ["irb"]
