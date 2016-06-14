Github Users
============

[![Build Status](https://travis-ci.org/eunomie/github-users.svg?branch=master)](https://travis-ci.org/eunomie/github-users)

A little application to display informations about github users.

Installation
------------

### Prerequisites

- Tested against `ruby 2.3.1`
- `rails 4`

### Setup

- `gem install bundler && bundle install`
- `bundle exec rake db:prepare`

### Tests

- `bundle exec rake test` to run all tests
- `bundle exec cucumber` to run cucumber tests
- `bundle exec rspec` to run rspec tests

You can also run `guard`.

### Usage

- `rails s`
- [http://localhost:3000](http://localhost:3000)

Contributing
------------

1. [Fork it](https://github.com/eunomie/github-users/fork)
1. Install dependencies (`bundle install`)
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Write and run tests (`bundle exec rake test`)
1. Commit your changes (`git commit -am 'Add some feature`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new _Pull Request_

LICENSE
-------

Please see [LICENSE][].

AUTHOR
------

Yves Brissaud, [@\_crev_](https://twitter.com/_crev_), [@eunomie](https://github.com/eunomie)

[LICENSE]: https://github.com/eunomie/github-users/blob/master/LICENSE
