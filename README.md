# HealthKeeper

As we have both Bootstrap and TailwindCSS installed inside the project we need to split them somehow.
> Thus, to utilize TailwindCSS make sure that you use the classes with the prefix.
If you want to add a `p-1` class then it should be `tw-p-1` now. 
But it does not apply to the states, for example, if you want to add a `p-2` on hover, then your class should be `hover:tw-p-2`.

> Also, in order to support hot reload of TailwindCSS class changes, you need to run Rails server with `./bin/dev` instead of `rails s`/`rails server`.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...