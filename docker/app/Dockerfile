FROM ruby:2.6.2-slim

RUN apt-get update -qq && apt-get install -y locales build-essential git default-libmysqlclient-dev
RUN sed -i 's/#.*ja_JP\.UTF/ja_JP\.UTF/' /etc/locale.gen
RUN locale-gen && update-locale LANG=ja_JP.UTF-8
RUN mkdir /app
WORKDIR /app
#COPY ./Gemfile Gemfile
#ADD Gemfile.lock /app/Gemfile.lock
#RUN bundle install

ADD . /app
