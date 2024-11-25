import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    this.makeDraggable();
  }

  makeScrollable() {
    // document.body.style.overflowX = "auto";
    // document.body.style.overflowY = "auto";
    // document.body.style.pointerEvents = "auto";
    const scrollElement = document.querySelector(".modal-open");
    scrollElement.style.overflow = "auto";
    // const modalBase = document.querySelector(".modal");
    // modalBase.style.zIndex = 100;
    // const modalDia = document.querySelector(".modal-dialog");
    // modalDia.style.pointerEvents = "auto";
  }

  makeDraggable() {
    const modalHeader = this.element.querySelector(".modal-header");
    const modalContent = this.element.querySelector(".modal-content");

    if (modalHeader && modalContent) {
      modalHeader.style.cursor = "move";

      let offsetX = 0,
        offsetY = 0,
        initialX = 0,
        initialY = 0;

      const onMouseMove = (event) => {
        const deltaX = event.clientX - initialX;
        const deltaY = event.clientY - initialY;
        offsetX += deltaX;
        offsetY += deltaY;
        modalContent.style.transform = `translate(${offsetX}px, ${offsetY}px)`;
        initialX = event.clientX;
        initialY = event.clientY;
      };

      const onMouseUp = () => {
        document.removeEventListener("mousemove", onMouseMove);
        document.removeEventListener("mouseup", onMouseUp);
      };

      modalHeader.addEventListener("mousedown", (event) => {
        initialX = event.clientX;
        initialY = event.clientY;
        document.addEventListener("mousemove", onMouseMove);
        document.addEventListener("mouseup", onMouseUp);
      });
    }
  }
}
