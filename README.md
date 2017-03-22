# Bearden [![CircleCI][badge]][circleci]

## Meta

* State: development
* Production: [https://bearden.artsy.net][production] | [Heroku][production_heroku]
* Staging: [https://bearden-staging.artsy.net][staging] | [Heroku][staging_heroku]
* GitHub: [https://github.com/artsy/bearden/][bearden]
* Point People: [@jonallured][jonallured], [@gnilekaw][gnilekaw]

## Setup

* Fork the project to your GitHub account

* Clone your fork:
  ```
  $ git clone git@github.com:your-github-username/bearden.git
  ```

* Read and run setup script:
  ```
  $ cat bin/setup
  $ bin/setup
  ```

## Tests

Once setup, you can run the tests like this:

```
$ bundle exec rake spec
```

Note: the default rake task is setup to run tests and Rubocop.

## Starting Server

Foreman is used to manage the server configuration, so starting a server is as
easy as:

```
$ foreman start
```

See the Procfile for more.

## Deploying

PRs merged to the `master` branch are automatically deployed to staging.
Production is automatically deployed upon merges to `release`. Create such a PR
with [this handy link][deploy].

[badge]: https://circleci.com/gh/artsy/bearden.svg?style=svg&circle-token=d5dcd30a0660190450379057eead64bbb53e00b8
[circleci]: https://circleci.com/gh/artsy/bearden/
[production]: https://bearden.artsy.com
[production_heroku]: https://dashboard.heroku.com/apps/bearden-production
[staging]: https://bearden-staging.artsy.com
[staging_heroku]: https://dashboard.heroku.com/apps/bearden-staging
[bearden]: https://github.com/artsy/bearden
[jonallured]: https://github.com/jonallured
[gnilekaw]: https://github.com/gnilekaw
[deploy]: https://github.com/artsy/bearden/compare/release...master?expand=1
