import { Controller } from "stimulus";
import Swal from "sweetalert2";

export default class extends Controller {
  static targets = ["form", "hide"];
  static values = {
    element: String,
  };

  editCol(e) {
    const [xhr, status] = e.detail;
    const targetRow = this.element;

    if (
      status == "OK" &&
      targetRow != null &&
      typeof targetRow != "undefined"
    ) {
      const html = xhr.response;
      const rows = this.hideTargets;

      // targetRow.classList.add("d-none");
      rows.forEach((row) => {
        row.classList.add("d-none");
      });
      targetRow.insertAdjacentHTML("beforeend", html);
    } else {
      this.sweetalertStatus(status.text, status);
    }
  }

  colBatal() {
    const rows = this.formTargets;
    rows.forEach((row) => {
      row.remove();
    });
    const revealRows = this.hideTargets;
    revealRows.forEach((row) => {
      row.classList.remove("d-none");
    });
  }

  addRow(e) {
    const [xhr, status] = e.detail;
    const targetRow = document.getElementById(this.elementValue);

    if (
      status == "OK" &&
      targetRow != null &&
      typeof targetRow != "undefined"
    ) {
      const html = xhr.response;
      targetRow.insertAdjacentHTML("beforeend", html);
    } else {
      this.sweetalertStatus(status.text, status);
    }
  }

  editRow(e) {
    const [xhr, status] = e.detail;
    const targetRow = this.element;

    if (
      status == "OK" &&
      targetRow != null &&
      typeof targetRow != "undefined"
    ) {
      const html = xhr.response;
      targetRow.classList.add("d-none");
      targetRow.insertAdjacentHTML("afterend", html);
    } else {
      console.log({ status });
    }
  }

  deleteRow(e) {
    const [message, status] = e.detail;
    const { resText } = JSON.parse(message.response);
    const targetRow = this.element;
    const parentTable = targetRow.parentElement;

    if (
      status == "OK" &&
      targetRow != null &&
      typeof targetRow != "undefined"
    ) {
      targetRow.remove();
      this.updateRowNumbers(parentTable);
      this.sweetalertStatus(resText, status);
    } else {
      console.log({ status });
      this.sweetalertStatus(resText, status);
    }
  }

  // get all number rows from 'parent element' target
  // to scope the selector within 'parent element'
  // and not disturb counter in other table
  updateRowNumbers(parent) {
    const rows = parent.querySelectorAll(".row-number");
    rows.forEach((row, index) => {
      row.textContent = index + 1; // Update nomor sesuai dengan urutan baru
    });
  }

  batal() {
    const targetRow = this.element;

    if (targetRow.previousElementSibling != null) {
      targetRow.previousElementSibling.classList.remove("d-none");
    }
    targetRow.remove();
  }

  processAjax(event) {
    const [message, status] = event.detail;
    const { resText, html_content } = JSON.parse(message.response);
    const targetRow = this.element;

    if (status == "OK") {
      targetRow.outerHTML = html_content;
      this.animateBackground(targetRow);
    } else {
      this.sweetalertStatus(resText, status);
    }
  }

  animateBackground(target) {
    target.animate(
      [
        {
          //from
          backgroundColor: "rgba(242, 245, 169, 1)",
        },
        {
          //to
          backgroundColor: "rgba(242, 245, 169, 0.8)",
        },
      ],
      10000,
    );
  }

  sweetalertStatus(text, status) {
    if (status == "Accepted") {
      Swal.fire({
        title: "Sukses",
        text: text,
        icon: "success",
        confirmButtonText: "Ok",
      });
    } else if (status == "OK") {
      Swal.fire({
        title: "Sukses",
        text: text,
        icon: "success",
        confirmButtonText: "Ok",
      });
    } else if (status == "Created") {
      Swal.fire({
        title: "Sukses",
        text: text,
        icon: "success",
        confirmButtonText: "Ok",
      });
    } else {
      Swal.fire({
        title: "Gagal",
        text: text,
        icon: "error",
        confirmButtonText: "Ok",
      });
    }
  }
}
