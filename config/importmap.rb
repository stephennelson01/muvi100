# config/importmap.rb
pin "application"

# Core
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus",    to: "stimulus.min.js", preload: true

# No stimulus-loading, no pin_all_from, no "controllers" pin.
# We import controllers manually in application.js (above).
