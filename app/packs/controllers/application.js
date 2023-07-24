import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Config for StimulusJS.
application.debug = false
window.Stimulus   = application

export { application }
