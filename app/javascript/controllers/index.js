import { application } from "./application"

// Auto-register all controllers in this directory (default stimulus-rails setup)
import { definitionsFromContext } from "@hotwired/stimulus-loading"
const context = require.context(".", true, /_controller\.js$/)
application.load(definitionsFromContext(context))

// Explicitly register our infinite scroll (in case autoload misses it)
import InfiniteScrollController from "./infinite_scroll_controller"
application.register("infinite-scroll", InfiniteScrollController)
