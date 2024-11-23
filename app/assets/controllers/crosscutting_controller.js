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
    "mitraExternalNonPemerintah",
    "ogpExternalNonPemerintah",
  ];

  connect() {}

  aktifkanTipeTerpilih(event) {
    const tipeTerpilih = event.detail.data.id;
    if (tipeTerpilih == "Internal") {
      this.internalForm();
      this.externalTarget.innerHTML = "";
    } else if (tipeTerpilih == "External") {
      this.externalForm();
      this.internalTarget.innerHTML = "";
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
      this.externalPemerintah();
      this.nonPemerintahTarget.innerHTML = "";
    } else if (tipeInstansi == "Non-Pemerintah") {
      this.externalNonPemerintah();
      this.pemerintahTarget.innerHTML = "";
    }
  }

  externalPemerintah() {
    const url = "/crosscuttings/external_pemerintah";

    fetch(url, { headers: { "X-Requested-With": "XMLHttpRequest" } })
      .then((response) => response.text())
      .then((html) => {
        this.pemerintahTarget.innerHTML = html;
      })
      .catch((error) => console.error("Error:", error));
  }

  externalNonPemerintah() {
    const url = "/crosscuttings/external_non_pemerintah";

    fetch(url, { headers: { "X-Requested-With": "XMLHttpRequest" } })
      .then((response) => response.text())
      .then((html) => {
        this.nonPemerintahTarget.innerHTML = html;
      })
      .catch((error) => console.error("Error:", error));
  }

  inputMitra(event) {
    const checkState = event.target.checked;
    const url = "/mitras/new_internal";

    if (checkState) {
      fetch(url, { headers: { "X-Requested-With": "XMLHttpRequest" } })
        .then((response) => response.text())
        .then((html) => {
          this.mitraTarget.innerHTML = html;
        })
        .catch((error) => console.error("Error:", error));
    } else {
      this.mitraTarget.innerHTML = "";
    }
  }

  inputMitraExternalPemerintah(event) {
    const checkState = event.target.checked;
    const url = "/mitras/new_external_pemerintah";

    if (checkState) {
      fetch(url, { headers: { "X-Requested-With": "XMLHttpRequest" } })
        .then((response) => response.text())
        .then((html) => {
          this.mitraExternalPemerintahTarget.innerHTML = html;
        })
        .catch((error) => console.error("Error:", error));
    } else {
      this.mitraExternalPemerintahTarget.innerHTML = "";
    }
  }

  inputMitraExternalNonPemerintah(event) {
    const checkState = event.target.checked;
    const url = "/mitras/new_external_non_pemerintah";

    if (checkState) {
      fetch(url, { headers: { "X-Requested-With": "XMLHttpRequest" } })
        .then((response) => response.text())
        .then((html) => {
          this.mitraExternalNonPemerintahTarget.innerHTML = html;
        })
        .catch((error) => console.error("Error:", error));
    } else {
      this.mitraExternalNonPemerintahTarget.innerHTML = "";
    }
  }

  inputInovasi(event) {
    const checkState = event.target.checked;
    const url = "/inovasi_tims/new_internal";

    if (checkState) {
      fetch(url, { headers: { "X-Requested-With": "XMLHttpRequest" } })
        .then((response) => response.text())
        .then((html) => {
          this.inovasiTarget.innerHTML = html;
        })
        .catch((error) => console.error("Error:", error));
    } else {
      this.inovasiTarget.innerHTML = "";
    }
  }

  inputOgpExternalNonPemerintah(event) {
    const checkState = event.target.checked;
    const url = "/mitras/new_external_non_pemerintah_ogp";

    if (checkState) {
      fetch(url, { headers: { "X-Requested-With": "XMLHttpRequest" } })
        .then((response) => response.text())
        .then((html) => {
          this.ogpExternalNonPemerintahTarget.innerHTML = html;
        })
        .catch((error) => console.error("Error:", error));
    } else {
      this.ogpExternalNonPemerintahTarget.innerHTML = "";
    }
  }
}
