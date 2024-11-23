# Manual Installation

1. Install Ruby `3.2.1`.
2. Create `.env` file in root folder of the project.
3. Install [PostgreSQL](https://www.postgresql.org/download/) `>=14.13`.
4. Add corresponded env vars to `.env` file with DB credentials. E.g.:
```
HEALTHKEEPER_DEVELOPMENT_DATABASE = "healthkeeper_development"
HEALTHKEEPER_DEVELOPMENT_DATABASE_USERNAME = "healthkeeper"
HEALTHKEEPER_DEVELOPMENT_DATABASE_PASSWORD = "magic"

HEALTHKEEPER_TEST_DATABASE = "healthkeeper_test"
HEALTHKEEPER_TEST_DATABASE_USERNAME = "healthkeeper"
HEALTHKEEPER_TEST_DATABASE_PASSWORD = "magic"
```
5. Run `./bin/bundle install`
6. Run `rails db:setup`.
7. In order to recreate DB run `rails db:reset`.
8. In order to (re)populate DB with a testing data run `rails db:seed`.
9. To run Rails server use `./bin/dev` instead of `rails s`/`rails server` (see [next chapter](#bootstrap-and-tailwindCSS) if curious why).

### Bootstrap and TailwindCSS
> In order to support hot reload of TailwindCSS class changes, you need to run Rails server with `./bin/dev` instead of `rails s`/`rails server`.
