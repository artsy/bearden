# Bearden [![CircleCI][badge]][circleci]

## Meta

* State: production
* Production: [https://bearden.artsy.net][production] | [Heroku][production_heroku]
* Staging: [https://bearden-staging.artsy.net][staging] | [Heroku][staging_heroku]
* GitHub: [https://github.com/artsy/bearden/][bearden]
* Point People: [@jonallured][jonallured]

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

Note: the default rake task is setup to run tests and RuboCop.

## Starting Server

Foreman is used to manage the server configuration, so starting a server is as
easy as `foreman start`, but you might want to use the development version
instead:

```
$ foreman start -f Procfile.dev
```

See the Procfile examples for more.

## Deploying

PRs merged to the `master` branch are automatically deployed to staging.
Production is automatically deployed upon merges to `release`. Create such a PR
with [`deploy_pr`][deploy_pr] or [this handy link][deploy].

## API

See [docs/API](docs/API.md).

## About the name Bearden

For its ability to "collage" together different data sources, this project was
named in honor of [Romare Bearden][romare] (1911–1988), painter, collagist and
founding member of [The Spiral Group][spiral].

> A pioneer of African-American art and celebrated collagist, Romare Bearden
> seamlessly blended images of African-American life in the urban and rural
> South with references to popular culture, religion, and Classical art and
> myth. He depicted jazz musicians, monumental subjects, nudes, or mythological
> characters set against abstract, fragmented backgrounds. Each of his collages
> integrated images painted in gouache, watercolors, oil paints, which he would
> then fix to paper or canvas. Bearden sought to give the African-American
> experience a universal, monumental, and Classical representation: he would
> often recast Classical events with African-American subjects, as in _The
> Return of Odysseus (Homage to Pintoricchio and Benin)_ (1977). By rendering
> Odysseus, Penelope, and Telemachus as African-Americans, Bearden drew the
> political injustices of his time into a universal, allegorical context. —Artsy

## License

MIT License. See [LICENSE](LICENSE).

[badge]: https://circleci.com/gh/artsy/bearden.svg?style=svg&circle-token=d5dcd30a0660190450379057eead64bbb53e00b8
[circleci]: https://circleci.com/gh/artsy/bearden/
[production]: https://bearden.artsy.net
[production_heroku]: https://dashboard.heroku.com/apps/bearden-production
[staging]: https://bearden-staging.artsy.net
[staging_heroku]: https://dashboard.heroku.com/apps/bearden-staging
[bearden]: https://github.com/artsy/bearden
[jonallured]: https://github.com/jonallured
[deploy_pr]: https://github.com/jonallured/deploy_pr
[deploy]: https://github.com/artsy/bearden/compare/release...master?expand=1
[romare]: https://www.artsy.net/artist/romare-bearden
[spiral]: https://www.artsy.net/gene/spiral-group
