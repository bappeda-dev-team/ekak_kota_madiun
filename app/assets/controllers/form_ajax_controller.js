import { Controller } from "stimulus";
import { Modal } from "bootstrap";
import Swal from "sweetalert2";
import Turbolinks from "turbolinks";

export default class extends Controller {
  static targets = ["errorContainer", "button"];
  static values = {
    elementId: String,
  };

  ajaxSuccess(e) {
    const [xhr] = e.detail;
    this.modalHider();
    this.sweetAlertSuccess(xhr.resText);
    if (this.hasElementIdValue) {
      this.partialAttacher(this.elementIdValue, xhr.attachmentPartial);
    }
  }

  ajaxSuccessAttach(e) {
    const [xhr] = e.detail;
    this.modalHider();
    this.sweetAlertSuccess(xhr.resText);
    if (this.hasElementIdValue) {
      const target = document.getElementById(this.elementIdValue);
      const html_element = xhr.attachmentPartial;
      target.innerHTML = html_element + target.innerHTML;
    }
  }

  ajaxDelete(e) {
    const [xhr] = e.detail;
    this.sweetAlertSuccess(xhr.resText);
    if (this.hasElementIdValue) {
      const target = document.getElementById(this.elementIdValue);
      target.remove();
    }
  }

  ajaxError(e) {
    const [xhr] = e.detail;
    this.sweetAlertFailed(xhr.resText);
    this.partialAttacher("form-modal-body", xhr.errors);
  }

  partialAttacher(targetName, html_element) {
    const target = document.getElementById(targetName);
    target.innerHTML = html_element;
  }

  processAjax(event) {
    // event.preventDefault()
    const [message, status] = event.detail;
    const { resText, html_content } = JSON.parse(message.response);
    if (status == "Unprocessable Entity") {
      this.partialAttacher("form-modal-body", html_content);
    } else {
      const target = document.getElementById(event.params.target);

      if (target != null && typeof target != "undefined") {
        if (event.params.type == "append") {
          target.insertAdjacentHTML("afterend", html_content);
          this.animateBackground(target.lastElementChild);
        } else if (event.params.type == "prepend") {
          target.insertAdjacentHTML("beforeend", html_content);
          this.animateBackground(target.lastElementChild);
        } else if (event.params.type == "afterbegin") {
          target.insertAdjacentHTML("afterbegin", html_content);
          this.animateBackground(target.firstChild);
        } else {
          target.innerHTML = html_content;
          this.animateBackground(target);
        }
      }
      this.sweetalertStatus(resText, status);
      const modal = event.params.modal;
      if (modal != null && typeof modal != "undefined") {
        this.modalHider(modal);
      } else {
        this.modalHider();
      }
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

  // modalName is standardize in layout/application.html.erb
  modalHider(modalName = "form-modal") {
    const modal = document.getElementById(modalName);
    Modal.getInstance(modal).hide();
  }

  sweetAlertSuccess(text) {
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

  afterSubmitRefresh(event) {
    const [xhr, status] = event.detail;
    if (status == "OK" || status == "Created") {
      const success = JSON.parse(xhr.response);
      Swal.fire({
        title: "Sukses",
        text: success.resText,
        icon: "success",
        confirmButtonText: "Ok",
      }).then(() => {
        Turbolinks.visit(window.location, { action: "replace" });
      });
    } else {
      const errors = JSON.parse(xhr.response);
      this.errorContainerTargets.forEach((errorContainer) => {
        const errorType = errorContainer.dataset.errorType;
        if (errors.hasOwnProperty(errorType)) {
          errorContainer.previousElementSibling.classList.add("is-invalid");
          errorContainer.innerHTML = errors[errorType];
          errorContainer.style.display = "inline";
        } else {
          errorContainer.style.display = "none";
        }
      });
      this.sweetalertStatus(errors.resText, "error");
    }
  }

  successResponseRefresh(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail;
    const modal_target = event.params.modal;
    const modal = document.getElementById(modal_target);
    // event after successResponse
    Modal.getInstance(modal).hide();
    if (status == "OK" || status == "Created") {
      Swal.fire({
        title: "Sukses",
        text: status,
        icon: "success",
        confirmButtonText: "Ok",
      }).then(() => {
        Turbolinks.visit(window.location, { action: "replace" });
      });
    } else {
      this.sweetalertStatus("terjadi kesalahan", "error");
    }
  }

  successResponse(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail;
    const modal_target = event.params.modal;
    const modal = document.getElementById(modal_target);
    const ajax_update_event = new CustomEvent("ajax-update", {
      detail: { data: message.result },
    });
    // event after successResponse
    Modal.getInstance(modal).hide();
    this.sweetalert(message.resText);
    window.dispatchEvent(ajax_update_event);
  }

  successResponseNew(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail;
    const modal = document.getElementById(event.params.modal);
    const target = document.getElementById(event.params.pohon);
    const { resText, html_content } = JSON.parse(message.response);

    Modal.getInstance(modal).hide();
    target.innerHTML = html_content;
    this.sweetalertStatus(resText, status);
  }

  successResponseTransferPohon(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail;
    this.sweetalertStatus(message.resText, status);
    const target_element = this.buttonTarget;
    target_element.innerHTML = message.result;
  }

  successResponseStrategiPohon(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail;
    const modal_target = event.params.modal;
    const modal = document.getElementById(modal_target);
    const id_strategi = `strategi_pohon_${message.result}`;
    const target_element = document.getElementById(id_strategi);
    const url = `/strategis/${message.result}`;
    // event after successResponse
    Modal.getInstance(modal).hide();
    fetch(url, {
      method: "get",
    })
      .then((response) => response.text())
      .then((text) => {
        this.sweetalertStatus(message.resText, status);
        target_element.innerHTML = text;
      })
      .catch((e) => {
        this.sweetalertStatus("terjadi kesalahan", "error");
      });
  }

  successResponseSpbe(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail;
    const modal_target = event.params.modal;
    const modal = document.getElementById(modal_target);
    const ajax_update_event = new CustomEvent("sasaran-new", {
      detail: { data: message },
    });
    // event after successResponse
    Modal.getInstance(modal).hide();
    this.sweetalert(message.resText);
    document.dispatchEvent(ajax_update_event);
  }

  successResponseBagikan(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail;
    const modal_target = event.params.modal;
    const modal = document.getElementById(modal_target);
    const ajax_update_event = new CustomEvent("ajax-update", {
      detail: { data: message.result },
    });
    // event after successResponse
    Modal.getInstance(modal).hide();
    this.sweetalertStatus(message.resText, status);
    window.dispatchEvent(ajax_update_event);
  }

  successResponseRenderNew(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail;
    const modal_target = event.params.modal;
    const modal = document.getElementById(modal_target);
    const ajax_update_event = new CustomEvent("ajax-update", {
      detail: { data: message.result },
    });
    // event after successResponse
    Modal.getInstance(modal).hide();
    const { roles, target } = message.result;
    const target_row = document.getElementById(target);
    target_row.innerHTML = `<ul>${roles
      .map((n) => `<li>${n}</li>`)
      .join("")}</ul>`;
    target_row.style.backgroundColor = "lime";
  }

  successWithoutModal(event) {
    const [message, status, xhr] = event.detail;
    // event after successResponse
    this.sweetalert(message.resText);
  }

  errorWithoutModal(event) {
    const [message, status] = event.detail;
    const errors = message.errors;
    this.errorContainerTargets.forEach((errorContainer) => {
      const errorType = errorContainer.dataset.errorType;
      const errorMsg = extractError({ errors, type: errorType });
      if (errorMsg === undefined) {
        errorContainer.style.display = "none";
      } else {
        errorContainer.previousElementSibling.classList.add("is-invalid");
        errorContainer.innerHTML = errorMsg;
        errorContainer.style.display = "inline";
      }
    });
  }

  responseAfter(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail;
    const modal = event.parentElement.parentElement.parentElement.parentElement;
    this.sweetalertStatus(message.resText, status);
    // event after successResponse
    Modal.getInstance(modal).hide();
  }

  afterClone(event) {
    const [message, status, _xhr] = event.detail;
    this.modalHider();
    const text = JSON.parse(message.response);
    this.sweetalertStatus(text.resText, status);
  }

  afterClonePokin(event) {
    const [message, status, _xhr] = event.detail;
    this.modalHider();
    const { resText, html_content } = JSON.parse(message.response);
    this.sweetalertStatus(resText, status);

    if (this.hasElementIdValue) {
      const target = document.getElementById(this.elementIdValue);
      target.insertAdjacentHTML("beforeend", html_content);
    }
  }

  modalHider(modalName = "form-modal") {
    const modal = document.getElementById(modalName);
    Modal.getInstance(modal).hide();
  }

  sweetalert(text) {
    Swal.fire({
      title: "Sukses",
      text: text,
      icon: "success",
      confirmButtonText: "Ok",
    });
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

function extractError({ errors, type }) {
  if (!errors || !Array.isArray(errors)) return;
  const foundError = errors.find(
    (error) => error.id.toLowerCase() === type.toLowerCase(),
  );
  return foundError?.title;
}
