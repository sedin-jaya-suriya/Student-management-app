import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.toast = new bootstrap.Toast(this.element)
    this.toast.show()
  }
}
