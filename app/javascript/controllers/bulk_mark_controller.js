import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["modal", "checkbox", "count", "submitButton"]

    connect() {
        this.updateState()
    }

    open(event) {
        event.preventDefault()
        this.modalTarget.classList.remove("hidden")
        document.body.classList.add("overflow-hidden")
    }

    close(event) {
        if (event) event.preventDefault()
        this.modalTarget.classList.add("hidden")
        document.body.classList.remove("overflow-hidden")
    }

    toggleAll(event) {
        event.preventDefault()
        const allChecked = this.checkboxTargets.every(c => c.checked)
        this.checkboxTargets.forEach(c => c.checked = !allChecked)
        this.updateState()
    }

    updateState() {
        const checkedCount = this.checkboxTargets.filter(c => c.checked).length

        // Update count text
        if (this.hasCountTarget) {
            this.countTarget.textContent = `${checkedCount} student${checkedCount === 1 ? '' : 's'} selected`
        }

        // Enable/disable submit button
        if (this.hasSubmitButtonTarget) {
            this.submitButtonTarget.disabled = checkedCount === 0
            if (checkedCount === 0) {
                this.submitButtonTarget.classList.add("opacity-50", "cursor-not-allowed")
            } else {
                this.submitButtonTarget.classList.remove("opacity-50", "cursor-not-allowed")
            }
        }
    }
}
