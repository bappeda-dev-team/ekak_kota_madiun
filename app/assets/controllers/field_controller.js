import { Controller } from "stimulus";

export default class extends Controller {
  toggle_visible(e) {
    const { data } = e.detail;
    const target = this.element;
    if (data.text.includes("Bukan")) {
      target.classList.add("d-none");
    } else {
      target.classList.remove("d-none");
    }
  }
}
