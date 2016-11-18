FROM ruby:2.3.1
MAINTAINER Yves Brissaud <yves@sogilis.com>
ENV REFRESHED_AT 2016-08-20
# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get install -qy nodejs && \
  apt-get -y clean && \
  apt-get -y autoclean && \
  apt-get -y autoremove && \
  rm -rf /var/lib/apt/* && \
  rm -rf /var/lib/cache/* && \
  rm -rf /var/lib/log/* && \
  rm -rf /tmp/*
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install --without test development --jobs 20 --retry 5
COPY . /usr/src/app
RUN RAILS_ENV=production AWS_REGION=deliberately_unset_region rake assets:precompile
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
