import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [
    "internal",
    "external",
    "mitra",
    "inovasi",
    "pemerintah",
    "nonPemerintah",
    "mitraExternalPemerintah",
    "inovasiExternalPemerintah",
    "mitraExternalNonPemerintah",
    "inovasiExternalNonPemerintah",
    "ogpExternalNonPemerintah",
  ];

  connect() {
    console.log("controller connected");
  }

  aktifkanTipeTerpilih(event) {
    const tipeTerpilih = event.detail.data.id;
    if (tipeTerpilih == "Internal") {
      this.internalForm();
    } else if (tipeTerpilih == "External") {
      this.externalForm();
    }
  }

  internalForm() {
    const url = "/crosscuttings/internal";

    fetch(url, { headers: { "X-Requested-With": "XMLHttpRequest" } })
      .then((response) => response.text())
      .then((html) => {
        this.internalTarget.innerHTML = html;
      })
      .catch((error) => console.error("Error:", error));
  }

  externalForm() {
    const url = "/crosscuttings/external";

    fetch(url, { headers: { "X-Requested-With": "XMLHttpRequest" } })
      .then((response) => response.text())
      .then((html) => {
        this.externalTarget.innerHTML = html;
      })
      .catch((error) => console.error("Error:", error));
  }

  aktifkanTipeInstansiTerpilih(event) {
    const tipeInstansi = event.detail.data.id;
    if (tipeInstansi == "Pemerintah") {
      this.pemerintahTarget.classList.toggle("d-none");
    } else if (tipeInstansi == "Non-Pemerintah") {
      this.nonPemerintahTarget.classList.toggle("d-none");
    }
  }

  inputMitra(_event) {
    const url = "/mitras/new_internal";

    fetch(url, { headers: { "X-Requested-With": "XMLHttpRequest" } })
      .then((response) => response.text())
      .then((html) => {
        this.mitraTarget.innerHTML = html;
      })
      .catch((error) => console.error("Error:", error));
  }

  inputMitraExternalPemerintah(_event) {
    const url = "/mitras/new_external_pemerintah";

    fetch(url, { headers: { "X-Requested-With": "XMLHttpRequest" } })
      .then((response) => response.text())
      .then((html) => {
        this.mitraExternalPemerintahTarget.innerHTML = html;
      })
      .catch((error) => console.error("Error:", error));
  }

  inputMitraExternalNonPemerintah(_event) {
    this.mitraExternalNonPemerintahTarget.classList.toggle("d-none");
  }

  inputInovasi(_event) {
    this.inovasiTarget.classList.toggle("d-none");
  }

  inputInovasiExternalPemerintah(_event) {
    this.inovasiExternalPemerintahTarget.classList.toggle("d-none");
  }

  inputInovasiExternalNonPemerintah(_event) {
    this.inovasiExternalNonPemerintahTarget.classList.toggle("d-none");
  }

  inputOgpExternalNonPemerintah(_event) {
    this.ogpExternalNonPemerintahTarget.classList.toggle("d-none");
  }
}
