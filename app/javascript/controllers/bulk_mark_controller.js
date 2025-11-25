import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["modal", "checkbox", "count", "submitButton"]

    connect() {
        this.updateState()
    }

    async markSkill(event) {
        event.preventDefault()
        const button = event.currentTarget
        const skillId = button.dataset.skillId
        const skillName = button.dataset.skillName

        // Get selected students
        const selectedCheckboxes = this.checkboxTargets.filter(c => c.checked)
        const studentIds = selectedCheckboxes.map(c => c.value)

        if (studentIds.length === 0) {
            alert("Please select at least one student first.")
            window.scrollTo({ top: 0, behavior: 'smooth' })
            return
        }

        // Remove confirmation dialog
        // if (!confirm(`Mark '${skillName}' as demonstrated for ${studentIds.length} student(s)?`)) {
        //   return
        // }

        // Show loading state on button
        const originalContent = button.innerHTML
        button.disabled = true
        button.innerHTML = `
            <div class="flex items-center gap-3">
                <div class="w-4 h-4 border-2 border-gray-300 border-t-primary rounded-full animate-spin"></div>
                <span class="text-sm flex-1 text-gray-700">Applying...</span>
            </div>
        `

        try {
            const response = await fetch(window.location.pathname.replace('/bulk_mark', '/bulk_mark_skills'), {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'text/vnd.turbo-stream.html',
                    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
                },
                body: JSON.stringify({
                    skill_id: skillId,
                    student_ids: studentIds
                })
            })

            if (response.ok) {
                const streamMessage = await response.text()
                await Turbo.renderStreamMessage(streamMessage)

                // Show success state briefly
                button.innerHTML = `
                    <div class="flex items-center gap-3">
                        <div class="w-4 h-4 text-green-500">✓</div>
                        <span class="text-sm flex-1 text-gray-900 font-medium">Applied!</span>
                    </div>
                `
                setTimeout(() => {
                    button.innerHTML = originalContent
                    button.disabled = false
                }, 2000)
            } else {
                throw new Error('Network response was not ok')
            }

        } catch (error) {
            console.error('Error:', error)
            alert('An error occurred. Please try again.')
            button.innerHTML = originalContent
            button.disabled = false
        }
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
