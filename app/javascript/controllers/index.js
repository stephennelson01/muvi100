import { application } from "./application"
import ModalController from "./modal_controller"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

application.register("modal", ModalController)

eagerLoadControllersFrom("controllers", application)

import HeroController from "./hero_controller"
application.register("hero", HeroController)
