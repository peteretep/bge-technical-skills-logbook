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
    // Toggle all sections in this category
    const sections = this.element.querySelectorAll('[data-controller="collapse"]')
    sections.forEach(section => {
      const controller = this.application.getControllerForElementAndIdentifier(section, "collapse")
      if (controller) controller.toggle()
    })
  }
}