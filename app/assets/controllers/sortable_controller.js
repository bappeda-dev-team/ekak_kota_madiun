import { Controller } from "stimulus";
import Sortable from "sortablejs";

export default class extends Controller {
  static targets = ["list"];

  connect() {
    this.sortable = Sortable.create(this.listTarget, {
      animation: 150,
      onEnd: this.end.bind(this),
    });
  }

  end(event) {
    const ids = this.sortable.toArray();
    fetch("/dasar_hukums/sort", {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .content,
      },
      body: JSON.stringify({ item: ids }),
    });
  }
}
