import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["newFields", "radio"]

  connect() {
    this.toggleNewFields()
  }

  toggleNewFields() {
    const selected = this.radioTargets.find(r => r.checked)
    if (selected && selected.value === "new") {
      this.newFieldsTarget.style.display = ""
    } else {
      this.newFieldsTarget.style.display = "none"
    }
  }
}
