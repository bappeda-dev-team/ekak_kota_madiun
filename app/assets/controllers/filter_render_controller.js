import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["results"];

  append(event) {
    const [_data, _status, xhr] = event.detail;
    // alert(status)
    this.resultsTarget.innerHTML = xhr.response;
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

  async loadResults(url) {
    try {
      const response = await fetch(url, {
        headers: { "X-Requested-With": "XMLHttpRequest" },
      });

      if (response.ok) {
        const target = "render-results";
        const element = document.getElementById(target);
        const data = await response.json();
        const html = data.html_content
        element.innerHTML = html; // Update results
      } else {
        this.error()
      }
    } catch (error) {
      console.error("Error fetching results:", error);
    }
  }
}
