import { Controller } from "@hotwired/stimulus"

// Stimulus controller for student form interactivity:
// - Live character counter on the name field
// - Disable/enable Save button based on required field completion
export default class extends Controller {
  static targets = ["name", "email", "age", "course", "city", "marks", "teacher", "submit", "counter"]
  static values  = { maxLength: { type: Number, default: 50 } }

  connect() {
    this.validate()
    this.countCharacters()
  }

  // Update the character counter for the name field
  countCharacters() {
    if (!this.hasNameTarget || !this.hasCounterTarget) return

    const length = this.nameTarget.value.length
    this.counterTarget.textContent = length

    // Visual feedback when approaching limit
    if (length >= this.maxLengthValue) {
      this.counterTarget.classList.add("text-danger")
      this.counterTarget.classList.remove("text-muted")
    } else {
      this.counterTarget.classList.remove("text-danger")
      this.counterTarget.classList.add("text-muted")
    }
  }

  // Enable/disable the submit button based on required fields
  validate() {
    if (!this.hasSubmitTarget) return

    const isValid = this.#allRequiredFieldsFilled()
    this.submitTarget.disabled = !isValid
  }

  // ---------- Private ----------

  #allRequiredFieldsFilled() {
    const checks = [
      { target: "name",   has: this.hasNameTarget,   value: () => this.nameTarget.value.trim() },
      { target: "email",  has: this.hasEmailTarget,  value: () => this.emailTarget.value.trim() },
      { target: "age",    has: this.hasAgeTarget,    value: () => this.ageTarget.value.trim() },
      { target: "course", has: this.hasCourseTarget, value: () => this.courseTarget.value.trim() },
      { target: "city",   has: this.hasCityTarget,   value: () => this.cityTarget.value.trim() },
      { target: "marks",  has: this.hasMarksTarget,  value: () => this.marksTarget.value.trim() }
    ]

    // Teacher is required only if the target exists (admin users)
    if (this.hasTeacherTarget) {
      checks.push({ target: "teacher", has: true, value: () => this.teacherTarget.value.trim() })
    }

    return checks.every(field => !field.has || field.value().length > 0)
  }
}
