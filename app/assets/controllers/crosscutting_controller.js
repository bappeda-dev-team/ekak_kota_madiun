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
      this.internalTarget.classList.toggle("d-none");
    } else {
      this.externalTarget.classList.toggle("d-none");
    }
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
    this.mitraTarget.classList.toggle("d-none");
  }

  inputMitraExternalPemerintah(_event) {
    this.mitraExternalPemerintahTarget.classList.toggle("d-none");
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
