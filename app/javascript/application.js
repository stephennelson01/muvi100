// app/javascript/application.js
import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"

import ModalController from "./controllers/modal_controller"
import InfiniteScrollController from "./controllers/infinite_scroll_controller"

const application = Application.start()
window.Stimulus = application // for console debugging

application.register("modal", ModalController)
application.register("infinite-scroll", InfiniteScrollController)
