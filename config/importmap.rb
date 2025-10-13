pin "application"
pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true


# Stimulus 本体＋ローダ
pin "@hotwired/stimulus",          to: "stimulus.min.js",        preload: true
pin "@hotwired/stimulus-loading",  to: "stimulus-loading.js",    preload: true
pin_all_from "app/javascript/controllers", under: "controllers"