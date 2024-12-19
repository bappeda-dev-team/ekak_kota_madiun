import { Controller } from "stimulus";
import print from "print-js";

export default class extends Controller {
  static targets = ["document"];
  static values = {
    title: String,
  };

  print() {
    window.print();
    // print({
    //   printable: this.documentTarget,
    //   type: "html",
    //   css: "https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css",
    //   repeatTableHeader: false,
    //   documentTitle: this.titleValue,
    // });
  }
}
