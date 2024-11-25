import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    this.makeDraggable();
  }

  makeScrollable() {
    const scrollElement = document.querySelector(".modal-open");
    scrollElement.style.overflow = "auto";
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
