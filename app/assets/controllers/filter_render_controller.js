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
}
