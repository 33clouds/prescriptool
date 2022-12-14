import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="prescription-list"
export default class extends Controller {
  static targets = ["modalqr"];

  connect() {
    this.selectedCard = null;
  }

  toggleItem(event) {
    const p = event.currentTarget;

    if (this.selectedCard)
      this.selectedCard.classList.remove("expand");

    if (this.selectedCard === p)
      this.selectedCard = null;
    else {
      p.classList.add("expand");
      this.selectedCard = p;
    }
  }

  swallow(event) {
    event.stopPropagation();
  }

  onModalShow(event) {
    // https://getbootstrap.com/docs/4.0/components/modal/#varying-modal-content
    // The triggering url has data-id (the relevant prescription id);
    // the method executes when the modal is shown. It is registered via
    // `show.bs.modal` event on the modal itself.
    const id = event.relatedTarget.dataset.id;
    this.modalqrTarget.src = `/prescriptions/${id}/qr`;
  }
}
