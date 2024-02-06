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
}
