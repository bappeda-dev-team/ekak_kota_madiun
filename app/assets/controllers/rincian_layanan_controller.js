import { Controller } from "stimulus";

export default class extends Controller {
  // target elements
  static targets = ["jalurLayanan", "modelLayanan", "inputJalur"];
  // values
  static values = {
    jalurLayanan: String,
  };

  // when target connected
  connect() {
    if (this.modelLayananTarget.value == "Online") {
      this.jalurLayananTarget.classList.remove("d-none");
      this.inputJalurTarget.value = this.jalurLayananValue;
    } else {
      this.inputJalurTarget.value = "";
    }
  }

  aktifkanJalurLayanan(event) {
    const modelLayanan = event.detail.data.id;
    if (modelLayanan == "Online") {
      this.jalurLayananTarget.classList.remove("d-none");
      this.inputJalurTarget.value = this.jalurLayananValue;
    } else {
      this.jalurLayananTarget.classList.add("d-none");
      this.inputJalurTarget.value = "";
    }
  }

  // cleanup
  disconnect() {}
}
