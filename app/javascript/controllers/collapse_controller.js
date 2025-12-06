// app/javascript/controllers/collapse_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "icon"]
  static values = { expanded: Boolean }

  connect() {
    if (!this.expandedValue) {
      this.collapse()
    }
  }

  toggle() {
    if (this.expandedValue) {
      this.collapse()
    } else {
      this.expand()
    }
  }

  expand() {
    this.contentTarget.style.display = "block"
    this.iconTarget.style.transform = "rotate(0deg)"
    this.expandedValue = true
  }

  collapse() {
    this.contentTarget.style.display = "none"
    this.iconTarget.style.transform = "rotate(-90deg)"
    this.expandedValue = false
  }

  toggleAll() {
    // Check if any sections are expanded
    const sections = this.element.querySelectorAll('[data-controller="collapse"]')
    const controllers = Array.from(sections).map(section =>
      this.application.getControllerForElementAndIdentifier(section, "collapse")
    ).filter(controller => controller !== null)

    // Determine if we should collapse or expand all
    const anyExpanded = controllers.some(controller => controller.expandedValue)

    // Collapse all if any are expanded, otherwise expand all
    controllers.forEach(controller => {
      if (anyExpanded) {
        controller.collapse()
      } else {
        controller.expand()
      }
    })
  }
}