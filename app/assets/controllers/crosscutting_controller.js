import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["internal", "external", "mitra", "inovasi"];

  connect() {
    console.log("controller connected");
  }

  aktifkanTipeTerpilih(event) {
    const tipeTerpilih = event.detail.data.id;
    if (tipeTerpilih == "Internal") {
      this.internalTarget.classList.toggle("d-none");
    } else {
      this.exeternalTarget.classList.toggle("d-none");
    }
  }

  inputMitra(_event) {
    this.mitraTarget.classList.toggle("d-none");
  }

  inputInovasi(_event) {
    this.inovasiTarget.classList.toggle("d-none");
  }
}
