# HealthKeeper

## Installation

1. Install Ruby `3.2.1`.
2. Create `.env` file in root folder of the project.
2. Install [PostgreSQL](https://www.postgresql.org/download/) `>=14.13`.
3. Add corresponded env vars to `.env` file with DB credentials. E.g.:
```
HEALTHKEEPER_DEVELOPMENT_DATABASE = "healthkeeper_development"
HEALTHKEEPER_DEVELOPMENT_DATABASE_USERNAME = "healthkeeper"
HEALTHKEEPER_DEVELOPMENT_DATABASE_PASSWORD = "magic"

HEALTHKEEPER_TEST_DATABASE = "healthkeeper_test"
HEALTHKEEPER_TEST_DATABASE_USERNAME = "healthkeeper"
HEALTHKEEPER_TEST_DATABASE_PASSWORD = "magic"
```
4. Run `./bin/bundle install`
5. Run `rails db:setup`.
6. In order to recreate DB run `rails db:reset`.
7. In order to (re)populate DB with a testing data run `rails db:seed`.
8. To run Rails server use `./bin/dev` instead of `rails s`/`rails server` (see [next chapter](#bootstrap-and-tailwindCSS) if curious why).

### Bootstrap and TailwindCSS
As we have both Bootstrap and TailwindCSS installed inside the project we need to split them somehow.
> Thus, to utilize TailwindCSS make sure that you use the classes with the prefix.
If you want to add a `p-1` class then it should be `tw-p-1` now.
But it does not apply to the states, for example, if you want to add a `p-2` on hover, then your class should be `hover:tw-p-2`.

> Also, in order to support hot reload of TailwindCSS class changes, you need to run Rails server with `./bin/dev` instead of `rails s`/`rails server`.

## How to run the test suite

TODO

## App scope to be done

### **High Priority**

1. [ ] **Health Data Management**
   - [ ] User Story 1: Manual input of blood test results.
   - [ ] User Story 2: Import health data from PDF files.
   - [x] User Story 4: Display health data with color-coded references.
2. [ ] **User Interface and Experience**
   - [ ] User Story 16: See trends in health data over a defined period.
3. [x] **Biomarker and Disease Database**
   - [x] User Story 22: Allow users to add their own reference databases.
4. [x] **Security**
   - [x] Authentication.
   - [x] Authorization.
   - [x] Role management.
      - [x] Tune role policies.
5. [ ] Wrap an app in Docker.