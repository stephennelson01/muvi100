import { application } from "./application"

// Importmap-friendly helpers:
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

// Auto-load everything in this directory:
eagerLoadControllersFrom("controllers", application)

// Explicit registrations (belt & suspenders)
import ModalController from "./modal_controller"
application.register("modal", ModalController)

import InfiniteScrollController from "./infinite_scroll_controller"
application.register("infinite-scroll", InfiniteScrollController)

// app/javascript/controllers/index.js
import { Application } from "@hotwired/stimulus"

// Start Stimulus and expose it for quick debugging in the console
const application = Application.start()
window.Stimulus = application


// If you have infinite scroll, uncomment and make sure the file exists:
// import InfiniteScrollController from "./infinite_scroll_controller"
// application.register("infinite-scroll", InfiniteScrollController)
