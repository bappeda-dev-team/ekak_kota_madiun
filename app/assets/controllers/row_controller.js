import { Controller } from "stimulus";

export default class extends Controller {
  static values = {
    element: String
  };

  addRow(e) {
    const [xhr, status] = e.detail;
    const targetRow = document.getElementById(this.elementValue);

    if (status == "OK" && targetRow != null && typeof targetRow != "undefined") {
      const html = xhr.response;
      targetRow.insertAdjacentHTML('afterbegin', html)
    } else {
      this.sweetalertStatus(status.text, status);
    }
  }

  editRow(e) {
    const [xhr, status] = e.detail;
    const targetRow = this.element;

    if (status == "OK") {
      const html = xhr.response;
      targetRow.classList.add("d-none");
      targetRow.insertAdjacentHTML("afterend", html);
    } else {
      this.sweetalertStatus(status.text, status);
    }
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

    if (status == "Unprocessable Entity") {
      // targetRow.outerHTML = html_content;
      // alert error here
      console.error({ error: resText })
    } else {
      targetRow.outerHTML = html_content;
      this.animateBackground(targetRow);
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
}
