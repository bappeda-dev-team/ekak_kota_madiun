import ApplicationController from "./application_controller";

export default class extends ApplicationController {
  static targets = [
    "table",
    "saveBtn",
    "editBtn",
    "formPlace",
    "formTable",
    "dinasTerkait",
    "ikuSasaran",
    "sasaranRpjmd",
  ];
  static values = {
    isInput: Boolean,
    url: String,
  };

  toggleInput() {
    this.isInputValue = !this.isInputValue;
    // switch button
    this.saveBtnTarget.classList.toggle("d-none");
    this.editBtnTarget.classList.toggle("btn-outline-danger");
    this.editBtnTarget.innerHTML = this.isInputValue
      ? `<i class="fas fa-times me-2"></i>Batal`
      : `<i class="fas fa-pencil-alt me-2"></i>Edit`;

    if (this.isInputValue) {
      this.showForm(this.urlValue);
    } else {
      this.formTableTarget.remove();
      // show table
      this.tableTarget.classList.remove("d-none");
    }
  }

  async showForm(url) {
    const element = this.formPlaceTarget;
    try {
      const response = await fetch(url, {
        headers: { "X-Requested-With": "XMLHttpRequest" },
      });

      if (response.ok) {
        const data = await response.json();
        const html = data.html_content;
        element.insertAdjacentHTML("beforeend", html);
        // hide table
        this.tableTarget.classList.add("d-none");
      } else {
        const html =
          '<div class="alert alert-danger" role="alert" data-form-table-target="formTable">Terjadi Kesalahan</div>';
        element.insertAdjacentHTML("beforeend", html);
      }
    } catch (error) {
      const html =
        '<div class="alert alert-danger" role="alert" data-form-table-target="formTable">Terjadi Kesalahan</div>';
      element.insertAdjacentHTML("beforeend", html);
    }
  }

  async saveData(event) {
    event.preventDefault();

    let formData = new FormData(this.formTableTarget);
    const formPost = await fetch(this.formTableTarget.action, {
      method: "POST",
      body: formData,
      headers: { "X-Requested-With": "XMLHttpRequest" },
    });

    // result containing two possible json html_content
    // this approach not handling connection error etc
    // 1. success, updated partial
    // 2. error, form partial with warning
    const result = await formPost.json();

    if (formPost.ok) {
      const element = this.formPlaceTarget;
      const html = result.html_content;
      this.toggleInput();
      element.innerHTML = html;
      super.sweetAlertSuccess("Konteks Risiko tersimpan.");
    } else {
      const element = this.formTableTarget;
      const html = result.html_content;
      element.outerHTML = html;
      super.sweetAlertFailed("Terjadi kesalahan.");
    }
  }

  fillAdditionalValue(e) {
    const { data } = e.detail;
    const dinas = data.dinas;
    this.fillDinasField(dinas);

    const iku = data.iku;
    this.fillIku(iku);

    const sasaran = data.text;
    this.fillSasaran(sasaran, iku);
  }

  fillDinasField(dinas) {
    this.dinasTerkaitTarget.innerHTML = "";
    dinas.forEach((dinasItem) => {
      let div = document.createElement("div");
      div.textContent = dinasItem;
      div.classList.add("dinas-item"); // Add class for styling
      this.dinasTerkaitTarget.appendChild(div);
    });
  }

  fillIku(iku) {
    this.ikuSasaranTarget.innerHTML = "";

    // Create table structure
    let table = document.createElement("table");
    table.classList.add("indikator-table");

    // Create and append header row
    let thead = document.createElement("thead");
    let headerRow = document.createElement("tr");

    let indikatorTh = document.createElement("th");
    indikatorTh.textContent = "Indikator";

    let targetTh = document.createElement("th");
    targetTh.textContent = "Target";

    headerRow.appendChild(indikatorTh);
    headerRow.appendChild(targetTh);
    thead.appendChild(headerRow);
    table.appendChild(thead);

    // Create and append body rows
    let tbody = document.createElement("tbody");

    iku.forEach((item) => {
      let row = document.createElement("tr");
      row.classList.add("indikator-row");

      let indikatorTd = document.createElement("td");
      indikatorTd.textContent = item.indikator;
      indikatorTd.classList.add("indikator-cell");

      let targetTd = document.createElement("td");
      targetTd.textContent = `${item.target} ${item.satuan}`;
      targetTd.classList.add("target-cell");

      row.appendChild(indikatorTd);
      row.appendChild(targetTd);
      tbody.appendChild(row);
    });
    table.appendChild(tbody);
    this.ikuSasaranTarget.appendChild(table);
  }

  fillSasaran(sasaran, iku) {
    this.sasaranRpjmdTarget.innerHTML = "";
    let table = document.createElement("table");
    table.classList.add("indikator-table");

    // Create and append header row
    let thead = document.createElement("thead");
    let headerRow = document.createElement("tr");

    let sasaranTh = document.createElement("th");
    sasaranTh.textContent = "Sasaran";

    let indikatorTh = document.createElement("th");
    indikatorTh.textContent = "Indikator";

    let targetTh = document.createElement("th");
    targetTh.textContent = "Target";

    headerRow.appendChild(sasaranTh);
    headerRow.appendChild(indikatorTh);
    headerRow.appendChild(targetTh);
    thead.appendChild(headerRow);
    table.appendChild(thead);
    // Create and append body rows
    let tbody = document.createElement("tbody");

    let rowSas = document.createElement("tr");
    rowSas.classList.add("indikator-row");

    let sasTd = document.createElement("td");
    sasTd.setAttribute("rowspan", iku.length + 1);
    sasTd.textContent = sasaran;
    sasTd.classList.add("indikator-cell");

    rowSas.appendChild(sasTd);
    tbody.appendChild(rowSas);

    iku.forEach((item) => {
      let row = document.createElement("tr");
      row.classList.add("indikator-row");

      let indikatorTd = document.createElement("td");
      indikatorTd.textContent = item.indikator;
      indikatorTd.classList.add("indikator-cell");

      let targetTd = document.createElement("td");
      targetTd.textContent = `${item.target} ${item.satuan}`;
      targetTd.classList.add("target-cell");

      row.appendChild(indikatorTd);
      row.appendChild(targetTd);
      tbody.appendChild(row);
    });
    table.appendChild(tbody);
    this.sasaranRpjmdTarget.appendChild(table);
  }
}
