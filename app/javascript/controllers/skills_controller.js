import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  async toggle(event) {
    const checkbox = event.target
    const studentId = checkbox.dataset.studentId
    const skillId = checkbox.dataset.skillId
    const demonstrated = checkbox.checked

    // Show loading state
    checkbox.disabled = true

    try {
      const response = await fetch(`/students/${studentId}/toggle_skill`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'text/vnd.turbo-stream.html',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({
          skill_id: skillId,
          demonstrated: demonstrated
        })
      })

      if (response.ok) {
        const streamMessage = await response.text()
        await Turbo.renderStreamMessage(streamMessage)
      } else {
        // Revert checkbox if failed
        checkbox.checked = !demonstrated
        alert('Failed to update skill')
        checkbox.disabled = false
      }
    } catch (error) {
      console.error('Error:', error)
      checkbox.checked = !demonstrated
      alert('Network error - please try again')
      checkbox.disabled = false
    }
  }
}