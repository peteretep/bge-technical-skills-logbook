import { Controller } from "@hotwired/stimulus"

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
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({
          skill_id: skillId,
          demonstrated: demonstrated
        })
      })
      
      if (!response.ok) {
        // Revert checkbox if failed
        checkbox.checked = !demonstrated
        alert('Failed to update skill')
      } else {
        // Update the date display without reloading
        const dateSpan = checkbox.parentElement.querySelector('.text-xs.text-gray-500')
        if (demonstrated && !dateSpan) {
          // Add date if it doesn't exist
          const newDate = document.createElement('span')
          newDate.className = 'text-xs text-gray-500'
          newDate.textContent = new Date().toLocaleDateString('en-GB', { day: '2-digit', month: 'short' })
          checkbox.parentElement.appendChild(newDate)
        } else if (!demonstrated && dateSpan) {
          // Remove date if unchecking
          dateSpan.remove()
        }
        
        // Update background color
        const row = checkbox.parentElement
        if (demonstrated) {
          row.classList.remove('bg-gray-50', 'hover:bg-gray-100')
          row.classList.add('bg-green-50')
        } else {
          row.classList.remove('bg-green-50')
          row.classList.add('bg-gray-50', 'hover:bg-gray-100')
        }
        
        // Could update counts here too, but that's complex
        // For now, just show a subtle success indicator
        checkbox.classList.add('ring-2', 'ring-green-400')
        setTimeout(() => checkbox.classList.remove('ring-2', 'ring-green-400'), 500)
      }
    } catch (error) {
      console.error('Error:', error)
      checkbox.checked = !demonstrated
      alert('Network error - please try again')
    } finally {
      checkbox.disabled = false
    }
  }
}