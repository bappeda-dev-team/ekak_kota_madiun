import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]
  static values = {
    model: String,
    placeholder: String,
    element: String,
    formTarget: String
  }

  add() {
    const model = this.modelValue
    const placeholder = this.placeholderValue
    const targetElement = this.elementValue
    const formTarget = this.formTargetValue
    const newElement = document.createElement(targetElement)

    newElement.className = "form-control mb-2"
    newElement.name = model
    newElement.placeholder = placeholder
    newElement.setAttribute("form", formTarget)

    this.containerTarget.appendChild(newElement)
  }
}
