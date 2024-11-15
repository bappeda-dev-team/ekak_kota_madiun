import { Controller } from "stimulus";
import Sortable, { MultiDrag } from "sortablejs";
import Swal from "sweetalert2";

Sortable.mount(new MultiDrag());

export default class extends Controller {
  static targets = ["list", "item", "actionBtn"];
  static values = { isSorting: Boolean };

  connect() {
    this.sortable = Sortable.create(this.listTarget, {
      multiDrag: true, // Enable the plugin
      selectedClass: "sortable-selected", // Class name for selected item
      fallbackTolerance: 3, // So that we can select items on mobile
      animation: 150,
      disabled: true,
      ghostClass: "dragged-ontop",
      onEnd: this.reorder.bind(this),
    });
  }

  // this function not universal
  // only applied in dasar hukum bab 1 renstra
  toggleSort(e) {
    this.isSortingValue = !this.isSortingValue;
    this.sortable.option("disabled", !this.isSortingValue);

    // styling button
    document.getElementById("simpan-urutan").classList.toggle("d-none");

    // urutkan btn
    const urutkanBtn = document.getElementById("urutkan");
    urutkanBtn.classList.toggle("btn-outline-danger");
    urutkanBtn.innerHTML = this.isSortingValue
      ? `<i class="fas fa-times me-2"></i>Batal`
      : `<i class="fas fa-sort me-2"></i>Urutkan Dasar Hukum`;

    // styling row table
    this.itemTargets.forEach((e) => e.classList.toggle("sortable"));

    // hide tombol
    this.actionBtnTargets.forEach((e) => e.classList.toggle("d-none"));
  }

  reorder(event) {
    // Triggered after each drag-and-drop event, but doesn't save to the server yet
    this.reorderedIds = this.sortable.toArray(); // Store reordered IDs for saving
  }

  saveOrder(event) {
    if (!this.reorderedIds) return;

    fetch("/dasar_hukums/sort", {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .content,
      },
      body: JSON.stringify({ item: this.reorderedIds }),
    }).then((response) => {
      if (response.ok) {
        Swal.fire({
          title: "Sukses",
          text: "Urutan disimpan",
          icon: "success",
          confirmButtonText: "Ok",
        });
        this.toggleSort(); // Exit sorting mode
      } else {
        Swal.fire({
          title: "Gagal",
          text: "Terjadi kesalahan, urutan tidak tersimpan",
          icon: "error",
          confirmButtonText: "Ok",
        });
      }
    });
  }
}
