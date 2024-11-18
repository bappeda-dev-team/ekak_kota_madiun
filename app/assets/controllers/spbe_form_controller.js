import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["optional"];

  hideOptionalField(e) {
    console.log(e);
    const data = e.detail.data;
    const selectedValue = data.id;

    if (selectedValue == "Tolak") {
      this.optionalTargets.forEach((e) => e.classList.toggle("d-none"));
    }
  }
}
