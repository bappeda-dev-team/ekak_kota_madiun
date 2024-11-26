import { Controller } from "stimulus";
import { patch } from "@rails/request.js";
import Swal from "sweetalert2";

export default class extends Controller {
  // target elements
  static targets = ["list", "button", "simpan", "pilih", "radio", "table"];
  // values
  static values = { isInputInovator: Boolean };

  // when target connected
  connect() {}

  toggleInovator() {
    this.isInputInovator = !this.isInputInovator;
    this.simpanTarget.classList.toggle("d-none");

    const pilihBtn = this.pilihTarget;
    pilihBtn.classList.toggle("btn-outline-danger");
    pilihBtn.innerHTML = this.isInputInovator
      ? `<i class="fas fa-times me-2"></i>Batal`
      : `<i class="fas fa-id-badge me-2"></i>Pilih Inovator`;

    this.buttonTargets.forEach((e) => {
      e.classList.toggle("d-none");
    });
    this.radioTargets.forEach((e) => {
      e.classList.toggle("d-none");
    });
  }

  simpan(e) {
    const sasaranId = e.params.sasaranId;

    // radio button list
    const inovators = Array.from(
      document.querySelectorAll("input[type='radio'].inovators"),
    );

    // send only they have value
    if (inovators != null && inovators != "undefined") {
      const checkedMap = inovators.map((inovator) => ({
        id: inovator.value,
        checked: inovator.checked,
      }));
      this.sendUpdateInovator(checkedMap, sasaranId);
      this.toggleInovator(); // Exit sorting mode
    }
  }

  async sendUpdateInovator(data, sasaranId) {
    try {
      const response = await patch(`/pelaksana/toggle_inovator`, {
        body: JSON.stringify({ inovatorState: data, sasaran_id: sasaranId }),
        contentType: "application/json",
        responseKind: "json",
      });

      if (response.ok) {
        const body = await response.json;
        this.tableTarget.innerHTML = body.html_content;
        this.sweetalert(body.resText);
      } else {
        this.sweetAlertFailed("");
      }
    } catch (error) {
      this.sweetAlertFailed(error);
    }
  }

  sweetalert(text) {
    Swal.fire({
      title: "Sukses",
      text: text,
      icon: "success",
      confirmButtonText: "Ok",
    });
  }

  sweetAlertFailed(text) {
    Swal.fire({
      title: "Gagal",
      text: text,
      icon: "error",
      confirmButtonText: "Ok",
    });
  }

  // cleanup
  disconnect() {}
}
