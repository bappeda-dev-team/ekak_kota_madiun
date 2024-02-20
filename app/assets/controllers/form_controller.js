import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["field", "password"];

  toggleVisible(e) {
    const target = e.currentTarget.previousElementSibling;
    const { type } = e.params;
    if (type == "password") {
      target.setAttribute("type", "text");
      e.currentTarget.dataset.formTypeParam = "text";
      e.currentTarget.firstElementChild.className = "far fa-eye-slash";
    } else {
      target.setAttribute("type", "password");
      e.currentTarget.dataset.formTypeParam = "password";
      e.currentTarget.firstElementChild.className = "far fa-eye";
    }
  }

  addNewField(e) {
    // let regexp, time;
    // time = new Date().getTime();
    // regexp = new RegExp($(event.currentTarget).data('id'), 'g')
    // $(event.currentTarget).before($(event.currentTarget).data('fields').replace(regexp, time))
    // event.preventDefault()
    const formTarget = e.currentTarget.previousElementSibling;
    const newEl = formTarget.cloneNode(true)
    formTarget.insertAdjacentElement("afterend", newEl);
  }
}
