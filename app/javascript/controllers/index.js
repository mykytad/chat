// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"
import MessageReadStatusController from "controllers/message_read_status_controller";

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)

application.register("message-read-status", MessageReadStatusController);