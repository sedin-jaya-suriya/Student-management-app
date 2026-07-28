import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "name",
    "email",
    "age",
    "course",
    "city",
    "marks",
    "teacher",
    "submit",
    "counter"
  ]

  static values = {
    maxLength: {
      type: Number,
      default: 50
    }
  }

  connect() {
    this.countCharacters()
    this.validate()
  }

  countCharacters() {
    if (
      !this.hasNameTarget ||
      !this.hasCounterTarget
    ) {
      return
    }

    const characterCount =
      this.nameTarget.value.length

    this.counterTarget.textContent =
      characterCount

    if (
      characterCount >=
      this.maxLengthValue
    ) {
      this.counterTarget.classList.add(
        "text-danger"
      )

      this.counterTarget.classList.remove(
        "text-muted"
      )
    } else {
      this.counterTarget.classList.remove(
        "text-danger"
      )

      this.counterTarget.classList.add(
        "text-muted"
      )
    }

    // Validate the form after the name changes.
    this.validate()
  }

  validate() {
    if (!this.hasSubmitTarget) {
      return
    }

    const requiredFields = [
      this.nameTarget,
      this.emailTarget,
      this.ageTarget,
      this.courseTarget,
      this.cityTarget,
      this.marksTarget
    ]

    const allFieldsFilled =
      requiredFields.every(
        field =>
          field.value.trim().length > 0
      )

    const teacherSelected =
      !this.hasTeacherTarget ||
      this.teacherTarget.value
        .trim()
        .length > 0

    this.submitTarget.disabled =
      !(
        allFieldsFilled &&
        teacherSelected
      )
  }
}