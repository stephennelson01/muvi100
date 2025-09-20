# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# We will NOT use stimulus-loading auto-discovery in production;
# instead, we explicitly load and register controllers.
pin "controllers", to: "controllers/index.js"

# If you have another controller (e.g., infinite scroll), add a direct pin:
# pin "controllers/infinite_scroll_controller", to: "controllers/infinite_scroll_controller.js"
