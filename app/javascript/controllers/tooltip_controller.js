import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tooltip"
export default class extends Controller {
  static values = {
    content: String
  }

  connect() {
    this.tooltipElement = null
    this.element.addEventListener('mouseenter', this.show.bind(this))
    this.element.addEventListener('mouseleave', this.hide.bind(this))
    this.element.addEventListener('click', this.toggleModal.bind(this))
  }

  disconnect() {
    this.element.removeEventListener('mouseenter', this.show.bind(this))
    this.element.removeEventListener('mouseleave', this.hide.bind(this))
    this.element.removeEventListener('click', this.toggleModal.bind(this))
    this.hide()
  }

  show() {
    if (this.tooltipElement) return

    this.tooltipElement = document.createElement('div')
    this.tooltipElement.className = 'absolute z-50 px-3 py-2 text-sm text-white bg-gray-900 rounded-lg shadow-lg max-w-xs'
    this.tooltipElement.style.pointerEvents = 'none'
    this.tooltipElement.textContent = this.contentValue

    document.body.appendChild(this.tooltipElement)
    this.positionTooltip()
  }

  hide() {
    if (this.tooltipElement) {
      this.tooltipElement.remove()
      this.tooltipElement = null
    }
  }

  positionTooltip() {
    if (!this.tooltipElement) return

    const rect = this.element.getBoundingClientRect()
    const tooltipRect = this.tooltipElement.getBoundingClientRect()

    // Position below the element
    let top = rect.bottom + window.scrollY + 5
    let left = rect.left + window.scrollX + (rect.width / 2) - (tooltipRect.width / 2)

    // Prevent tooltip from going off the right edge
    if (left + tooltipRect.width > window.innerWidth) {
      left = window.innerWidth - tooltipRect.width - 10
    }

    // Prevent tooltip from going off the left edge
    if (left < 0) {
      left = 10
    }

    this.tooltipElement.style.top = `${top}px`
    this.tooltipElement.style.left = `${left}px`
  }

  toggleModal(event) {
    event.preventDefault()
    event.stopPropagation()

    // Check if modal already exists
    let modal = document.getElementById('eo-modal')

    if (modal) {
      this.closeModal()
      return
    }

    // Create modal
    modal = document.createElement('div')
    modal.id = 'eo-modal'
    modal.className = 'fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50'
    modal.innerHTML = `
      <div class="bg-white rounded-lg shadow-xl max-w-lg w-full mx-4 p-6">
        <div class="flex justify-between items-start mb-4">
          <h3 class="text-lg font-semibold text-gray-900">Scottish Curriculum for Excellence</h3>
          <button class="text-gray-400 hover:text-gray-600 text-2xl leading-none" data-action="click->tooltip#closeModal">
            &times;
          </button>
        </div>
        <div class="mb-4">
          <span class="inline-block px-3 py-1 bg-purple-100 text-purple-700 text-sm font-medium rounded mb-3">
            ${this.element.textContent.trim()}
          </span>
          <p class="text-gray-700 leading-relaxed">
            ${this.contentValue}
          </p>
        </div>
        <div class="flex justify-end">
          <button class="px-4 py-2 bg-gray-200 hover:bg-gray-300 text-gray-800 rounded" data-action="click->tooltip#closeModal">
            Close
          </button>
        </div>
      </div>
    `

    document.body.appendChild(modal)

    // Close on background click
    modal.addEventListener('click', (e) => {
      if (e.target === modal) {
        this.closeModal()
      }
    })

    // Close on escape key
    this.escapeHandler = (e) => {
      if (e.key === 'Escape') {
        this.closeModal()
      }
    }
    document.addEventListener('keydown', this.escapeHandler)
  }

  closeModal() {
    const modal = document.getElementById('eo-modal')
    if (modal) {
      modal.remove()
    }
    if (this.escapeHandler) {
      document.removeEventListener('keydown', this.escapeHandler)
      this.escapeHandler = null
    }
  }
}
