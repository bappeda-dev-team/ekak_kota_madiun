import { Controller } from "stimulus";
// datepicker
import flatpickr from "flatpickr";
import "flatpickr/dist/flatpickr.css";
import { Indonesian } from "flatpickr/dist/l10n/id";

export default class extends Controller {
  static targets = ["input"];

  connect() {
    this.initFlatpickr();
  }

  initFlatpickr() {
    flatpickr(this.inputTarget, {
      dateFormat: "d F Y",
      defaultDate: "today",
      locale: Indonesian,
    });
  }

  disconnect() {
    // Clean up Flatpickr instance when the controller disconnects
    if (this.flatpickrInstance) {
      this.flatpickrInstance.destroy();
    }
  }
}
