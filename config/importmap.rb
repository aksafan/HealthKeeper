# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "../../../../.rbenv/versions/3.2.1/lib/ruby/gems/3.2.0/gems/turbo-rails-2.0.10/app/assets/javascripts/turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "../app/javascript/controllers", under: "controllers"
