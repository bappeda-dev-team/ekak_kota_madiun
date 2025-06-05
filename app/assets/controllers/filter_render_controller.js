import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["results"];
  static values = {
    targetId: String,
    text: String,
    fieldDisabled: Boolean,
  };

  append(event) {
    const [_data, _status, xhr] = event.detail;
    // alert(status)
    if (this.hasTargetIdValue) {
      const target = document.getElementById(this.targetIdValue);
      target.innerHTML = xhr.response;
    } else {
      const target = (this.resultsTarget.innerHTML = xhr.response);
      target.innerHTML = xhr.response;
    }
  }

  warning(event) {
    const [_data, status, _xhr] = event.detail;
    alert(status);
  }

  success(event) {
    const [, , xhr] = event.detail;
    const target = "render-results";
    const element = document.getElementById(target);
    const html = xhr.response;
    element.innerHTML = html;
  }

  error() {
    const target = "render-results";
    const element = document.getElementById(target);
    const html =
      '<div class="alert alert-danger" role="alert">Terjadi Kesalahan</div>';
    element.innerHTML = html;
  }

  getRender(event) {
    const form = event.currentTarget;
    const url = new URL(form.action || window.location.href);
    const params = new URLSearchParams(new FormData(form));
    // Update URL with new query parameters
    window.history.pushState({}, "", `?${params.toString()}`);

    // Fetch new filtered results
    this.loadResults(url.pathname + "?" + params.toString());
  }

  loading() {
    const element = document.getElementById(this.targetIdValue);
    element.innerHTML = this.loaderView();
  }

  toggleDisableField() {
    const disable = !this.fieldDisabledValue;
    const fieldElements = this.element.querySelectorAll('input, select, textarea')

    fieldElements.forEach((field) => {
      field.disabled = disable;
    });

    this.fieldDisabledValue = disable;
  }

  loaderView() {
    return `
      <div class="loader text-center">
        <div class="lds-roller">
          <div></div><div></div><div></div><div></div>
          <div></div><div></div><div></div><div></div>
        </div>
        <p>${this.textValue}</p>
      </div>`;
  }

  async loadResults(url) {
    try {
      const response = await fetch(url, {
        headers: { "X-Requested-With": "XMLHttpRequest" },
      });

      if (response.ok) {
        const target = "render-results";
        const element = document.getElementById(target);
        const data = await response.json();
        const html = data.html_content;
        element.innerHTML = html; // Update results
      } else {
        this.error();
      }
    } catch (error) {
      console.error("Error fetching results:", error);
    }
  }
}
