FROM alpine:3.2

MAINTAINER Fabiano Beselga <fabianobeselga@gmail.com>

RUN apk add --update ruby ruby-rdoc ruby-irb

RUN apk add --update ruby-bundler
RUN apk add --update ruby-nokogiri
RUN apk add --update postgresql-client
RUN apk add --update imagemagick
RUN apk add --update nodejs
RUN apk add --update ruby-tzinfo
RUN apk add --update ruby-rake
RUN apk add --update ruby-bigdecimal

RUN mkdir /app

WORKDIR /tmp
COPY Gemfile* /tmp/
RUN apk add --update g++ make libxml2-dev libxslt-dev zlib-dev git postgresql-dev ruby-dev ruby-io-console && \
    bundle install -j 3 && \
    apk del --purge -r g++ make libxml2-dev libxslt-dev zlib-dev git postgresql-dev ruby-dev

WORKDIR /app
ADD . /app

RUN spree install . -A

RUN bin/rake log:clear tmp:clear
CMD bundle exec rails s -p 3000 -b '0.0.0.0'
