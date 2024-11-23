# Docker Installation

1. Make sure you have [docker](https://docs.docker.com/desktop/) and [docker-compose](https://docs.docker.com/compose/install/) installed and run.
2. Install GNU Make tool if you are not on Linux.
3. Add corresponded env vars to `.env` file with DB credentials. E.g.:
```
HEALTHKEEPER_DEVELOPMENT_DATABASE = "healthkeeper_development"
HEALTHKEEPER_DEVELOPMENT_DATABASE_USERNAME = "healthkeeper"
HEALTHKEEPER_DEVELOPMENT_DATABASE_PASSWORD = "magic"

HEALTHKEEPER_TEST_DATABASE = "healthkeeper_test"
HEALTHKEEPER_TEST_DATABASE_USERNAME = "healthkeeper"
HEALTHKEEPER_TEST_DATABASE_PASSWORD = "magic"
```
4. Run `make init` in order to build and start an application.
5. Now an App could be accessed on http://127.0.0.1:3000.
